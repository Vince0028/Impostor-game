
-- 1. Create a table for public profiles using Supabase Auth
create table profiles (
  id uuid references auth.users on delete cascade not null primary key,
  updated_at timestamp with time zone default timezone('utc'::text, now()),
  username text unique,
  avatar_url text,
  website text,

  constraint username_length check (char_length(username) >= 3)
);

-- 2. Set up Row Level Security (RLS)
-- Enable RLS
alter table profiles enable row level security;

-- Create Policy: Public profiles are viewable by everyone
create policy "Public profiles are viewable by everyone."
  on profiles for select
  using ( true );

-- Create Policy: Users can insert their own profile
create policy "Users can insert their own profile."
  on profiles for insert
  with check ( auth.uid() = id );

-- Create Policy: Users can update their own profile
create policy "Users can update own profile."
  on profiles for update
  using ( auth.uid() = id );

-- 3. Create a Trigger to auto-create profile on signup
-- This ensures that when a user signs up via Auth, a row is added to 'profiles'
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, username)
  values (new.id, new.raw_user_meta_data ->> 'username');
  return new;
end;
$$;

-- Drop trigger if exists to allow idempotency in scripts usually, but here just creating
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
