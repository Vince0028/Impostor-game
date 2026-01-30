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
    // Use cardPurple for Imposter/Incognito to be distinct but cool
    // Or use alertColor if we want it to be very obvious, but maybe revealing it should be subtle at first if the UI is shared?
    // Ah, this is the "Reveal" screen for the player.
    final cardColor = isImposter ? AppTheme.imposterColor : widget.cardColor;

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
                color: cardColor.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: _isRevealed
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
            style: AppTheme.titleLarge.copyWith(fontSize: 32, letterSpacing: 2),
          ),
          const SizedBox(height: 16),
          Text(
            'Keep your identity secret.\nDo not show other agents.',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textPrimary.withOpacity(0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Hold indicator
          AnimatedOpacity(
            opacity: _isHolding ? 0.5 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Column(
              children: [
                Icon(
                  Icons
                      .fingerprint, // Changed icon to fingerprint for spy theme
                  size: 64,
                  color: AppTheme.textPrimary.withOpacity(0.8),
                ),
                const SizedBox(height: 16),
                Text(
                  'SCAN TO REVEAL', // Changed text
                  style: AppTheme.labelLarge.copyWith(
                    color: AppTheme.textPrimary.withOpacity(0.8),
                    letterSpacing: 2,
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
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.backgroundSurface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: isImposter
                      ? AppTheme.alertColor
                      : AppTheme.primaryNeon,
                  width: 2,
                ),
              ),
              child: isImposter
                  ? Column(
                      children: [
                        Text(
                          'STATUS: COMPROMISED',
                          style: AppTheme.labelLarge.copyWith(
                            color: AppTheme.alertColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'YOU ARE\nINCOGNITO',
                          style: AppTheme.titleLarge.copyWith(
                            fontSize: 36,
                            color: AppTheme.alertColor,
                            letterSpacing: 2,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (widget.hint != null) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.alertColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Intel: ${widget.hint}',
                              style: AppTheme.bodyMedium.copyWith(
                                fontStyle: FontStyle.italic,
                                color: AppTheme.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ],
                    )
                  : Column(
                      children: [
                        Text(
                          'SECRET PASSCODE',
                          style: AppTheme.labelLarge.copyWith(
                            color: AppTheme.primaryNeon,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.word,
                          style: AppTheme.titleLarge.copyWith(
                            fontSize: 32,
                            color: AppTheme.primaryNeon,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 32),

            // Instructions
            Text(
              isImposter
                  ? 'Blend in. Deceive. Survive.'
                  : 'Memorize the code. Identify the spy.',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textPrimary.withOpacity(0.8),
                fontSize: 16,
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
      _isRevealed = false; // Hide content when released
    });
    _animationController.reverse();
  }
}
