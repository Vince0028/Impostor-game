<div align="center">

  <h1>PROJECT INCOGNITO</h1>
  <h3>The Ultimate Cyberpunk Social Deduction Game</h3>
  <p>
    A high-tech, immersive party game where one agent is rogue. Gather your friends, pass the device, and uncover the impostor before it's too late!
  </p>

  <p>
    <a href="#features">Features</a> •
    <a href="#tech-stack">Tech Stack</a> •
    <a href="#getting-started">Getting Started</a> •
    <a href="#license">License</a>
  </p>

  <div align="center">
    <!-- Flutter -->
    <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
    <!-- Dart -->
    <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
    <!-- Supabase -->
    <img src="https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white" alt="Supabase" />
    <!-- Android -->
    <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android" />
    <!-- iOS -->
    <img src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white" alt="iOS" />
  </div>
</div>

<br />

## 🌟 Introduction

**Project Incognito** turns your gathering into a high-stakes mission. Built with **Flutter** for a silky-smooth cross-platform experience and **Supabase** for robust backend reliability, this app brings the classic "Who is the Imposter?" game into the cyberpunk era.

Whether you're at a party, a family dinner, or just hanging out with friends, Project Incognito challenges your deception and deduction skills. With a sleek dark mode interface and intuitive "pass-and-play" mechanics, it's the perfect digital companion for real-world fun.

## ✨ Features

- **🕵️ Rogue Agent Mechanics**: Experience thrilling social deduction gameplay where one (or more) players are the hidden imposters trying to blend in.
- **📱 Seamless Pass-and-Play**: Designed for local multiplayer—no need for everyone to have the app. Just pass the phone securely to reveal roles.
- **🎨 Cyberpunk Aesthetics**: Immerse yourself in a stunning interface featuring neon accents, dark modes, and futuristic animations.
- **📂 Diverse Word Banks**: Access a massive library of secret words across multiple categories to keep every round fresh and challenging.
- **🔐 Secure Authentication**: Integrated with Supabase Auth for secure user profiles and settings management.
- **⚙️ Custom Game Settings**: Adjust round timers, player counts, and category preferences to tailor the game to your group.
- **📊 Cloud Sync**: (Upcoming) Track your win rates and stats across devices.

## 🛠 Tech Stack

| Component | Technology | Description |
|-----------|------------|-------------|
| **Framework** | [Flutter](https://flutter.dev/) | Google's UI toolkit for building natively compiled applications. |
| **Language** | [Dart](https://dart.dev/) | Client-optimized language for fast apps on any platform. |
| **Backend / DB** | [Supabase](https://supabase.com/) | Open source Firebase alternative for Auth and Database. |
| **State Management** | [Provider](https://pub.dev/packages/provider) | Efficient and scalable state management solution. |
| **Assets** | [Cupertino Icons](https://pub.dev/packages/cupertino_icons) | High-quality icons for a polished feel. |
| **Utils** | [Share Plus](https://pub.dev/packages/share_plus) | Integrating platform-native sharing capabilities. |

## 🚀 Getting Started

Follow these steps to set up the project locally on your machine.

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable version)
- [Git](https://git-scm.com/)

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/Vince0028/Impostor-game.git
    cd Impostor-game/impostor_game
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Configure Environment Variables**
    Create a `.env` file in the `impostor_game` root directory (if it doesn't verify automatically) and add your Supabase keys:

    ```env
    SUPABASE_URL=your_supabase_project_url
    SUPABASE_ANON_KEY=your_supabase_anon_key
    ```
    > **Note**: You will need a Supabase project set up to get these credentials.

4.  **Run the application**
    ```bash
    flutter run
    ```

## 📸 Usage

1.  **Sign In**: secure login to access your profile.
2.  **Setup Game**: Choose your category and number of players in the settings.
3.  **Pass the Phone**: Each player takes the device, views their secret role (Citizen or Imposter), and passes it to the next person.
4.  **Debate & Vote**: Once all roles are assigned, start the timer and debate amongst yourselves to find the impostor!
5.  **Reveal**: Check the reveal screen to see if your deductions were correct.

## 📞 Contact

Vince Alobin - [GitHub Profile](https://github.com/Vince0028)

---

<div align="center">
  <sub>Built with ❤️ by Vince using Flutter & Supabase</sub>
</div>