import 'package:flutter/material.dart';
import 'dart:math';
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

class _PlayerCardState extends State<PlayerCard> with TickerProviderStateMixin {
  bool _isHolding = false;
  late AnimationController _scaleController;
  late AnimationController _flipController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: pi).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutBack),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PlayerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.player.id != oldWidget.player.id) {
      // Reset state for new player
      _isHolding = false;
      _scaleController.reset();
      _flipController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isImposter = widget.player.isImposter;
    // Determine card color for revealed state
    final revealedColor = isImposter
        ? AppTheme.imposterColor
        : widget.cardColor;

    return GestureDetector(
      onLongPressStart: (_) => _onHoldStart(),
      onLongPressEnd: (_) => _onHoldEnd(),
      onLongPressCancel: () => _onHoldEnd(),
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _flipAnimation]),
        builder: (context, child) {
          final angle = _flipAnimation.value;
          final isFront = angle < pi / 2;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            ..rotateY(angle)
            ..scale(_scaleAnimation.value);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: isFront
                ? _buildCardContainer(
                    child: _buildHiddenContent(),
                    color: widget.cardColor, // Front always shows player color
                  )
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _buildCardContainer(
                      child: _buildRevealedContent(isImposter),
                      color: revealedColor,
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildCardContainer({required Widget child, required Color color}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: child, // Content is built by specific methods
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
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Keep your identity secret.\nHold to reveal.',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textPrimary.withOpacity(0.8),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 48),

          // Hold indicator
          AnimatedOpacity(
            opacity: _isHolding ? 0.6 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppTheme.textPrimary.withOpacity(0.8),
                      // Glow effect when holding
                      _isHolding
                          ? AppTheme.primaryNeon
                          : AppTheme.textPrimary.withOpacity(0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  child: const Icon(
                    Icons.fingerprint,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'SCAN IDENTITY',
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
              textAlign: TextAlign.center,
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
                            fontSize: 32,
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
    _scaleController.forward();

    // Reveal after 500ms of holding
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_isHolding && mounted) {
        _flipController.forward();
        widget.onCardRevealed();
      }
    });
  }

  void _onHoldEnd() {
    setState(() {
      _isHolding = false;
    });
    // Reverse animations
    _scaleController.reverse();
    _flipController.reverse();
  }
}
