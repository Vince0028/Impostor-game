import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../theme/app_theme.dart';

class PlayerCard extends StatefulWidget {
  final Player player;
  final String word;
  final String? hint;
  final Color cardColor;
  final VoidCallback onCardRevealed;

  const PlayerCard({
    super.key,
    required this.player,
    required this.word,
    this.hint,
    required this.cardColor,
    required this.onCardRevealed,
  });

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard>
    with SingleTickerProviderStateMixin {
  bool _isRevealed = false;
  bool _isHolding = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PlayerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.player.id != oldWidget.player.id) {
      setState(() {
        _isRevealed = false;
        _isHolding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isImposter = widget.player.isImposter;
    final cardColor = isImposter ? AppTheme.cardPurple : widget.cardColor;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: GestureDetector(
        onLongPressStart: (_) => _onHoldStart(),
        onLongPressEnd: (_) => _onHoldEnd(),
        onLongPressCancel: () => _onHoldEnd(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: cardColor.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: _isRevealed || widget.player.hasSeenCard
              ? _buildRevealedContent(isImposter)
              : _buildHiddenContent(),
        ),
      ),
    );
  }

  Widget _buildHiddenContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.player.name.toUpperCase(),
            style: AppTheme.titleLarge.copyWith(fontSize: 28, letterSpacing: 2),
          ),
          const SizedBox(height: 16),
          Text(
            'Do not tell the word to other\nplayers.',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textPrimary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Hold indicator
          AnimatedOpacity(
            opacity: _isHolding ? 0.5 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Column(
              children: [
                Icon(
                  Icons.touch_app,
                  size: 48,
                  color: AppTheme.textPrimary.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 8),
                Text(
                  'HOLD TO REVEAL',
                  style: AppTheme.labelLarge.copyWith(
                    color: AppTheme.textPrimary.withValues(alpha: 0.6),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevealedContent(bool isImposter) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.player.name.toUpperCase(),
              style: AppTheme.titleLarge.copyWith(
                fontSize: 28,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 32),

            // Word/Imposter Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: isImposter
                  ? Column(
                      children: [
                        Text(
                          'YOU ARE THE',
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'IMPOSTER!',
                          style: AppTheme.titleLarge.copyWith(
                            fontSize: 32,
                            color: AppTheme.imposterRed,
                            letterSpacing: 2,
                          ),
                        ),
                        if (widget.hint != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Hint: ${widget.hint}',
                            style: AppTheme.bodyMedium.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    )
                  : Text(
                      widget.word,
                      style: AppTheme.titleLarge.copyWith(fontSize: 28),
                      textAlign: TextAlign.center,
                    ),
            ),

            const SizedBox(height: 24),

            // Instructions
            Text(
              isImposter
                  ? 'Blend in! Don\'t let them know you\'re the imposter.'
                  : 'Remember this word. Don\'t say it directly!',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textPrimary.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _onHoldStart() {
    setState(() {
      _isHolding = true;
    });
    _animationController.forward();

    // Reveal after 500ms of holding
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_isHolding && mounted) {
        setState(() {
          _isRevealed = true;
        });
        widget.onCardRevealed();
      }
    });
  }

  void _onHoldEnd() {
    setState(() {
      _isHolding = false;
    });
    _animationController.reverse();
  }
}
