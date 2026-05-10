import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myan_nihongo/core/enums/app_enums.dart';
import 'package:myan_nihongo/core/theme/app_theme.dart';
import '../../../data/models/vocabulary_item_model.dart';
import 'learning_card_components.dart';
import 'recall_card_widget.dart';
import 'absorb_card_widget.dart';

class SwipeableVocabularyCard extends StatefulWidget {
  final VocabularyItemModel item;
  final VocabularyItemModel? nextItem;
  final String learningMode;
  final AnimationController flipController;
  final bool isBookmarked;
  final VoidCallback onFlipTap;
  final Future<void> Function(String text)? onSpeak;
  final VoidCallback? onBookmarkToggle;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final Function(double progress, bool isRight)? onSwipeUpdate;
  final VoidCallback? onSwipeCancel;

  const SwipeableVocabularyCard({
    super.key,
    required this.item,
    this.nextItem,
    required this.learningMode,
    required this.flipController,
    required this.isBookmarked,
    required this.onFlipTap,
    this.onSpeak,
    this.onBookmarkToggle,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    this.onSwipeUpdate,
    this.onSwipeCancel,
  });

  @override
  State<SwipeableVocabularyCard> createState() =>
      _SwipeableVocabularyCardState();
}

class _SwipeableVocabularyCardState extends State<SwipeableVocabularyCard>
    with TickerProviderStateMixin {
  Offset _dragOffset = Offset.zero;
  bool _isSwiping = false;
  bool _isAnimatingAway = false;
  bool _hasTriggeredHaptic = false;
  AnimationController? _animController;
  Animation<Offset>? _offsetAnimation;

  static const double _swipeThreshold = 96.0;
  static const double _maxRotation = 0.16;
  static const double _cardRadius = 28.0;
  static const double _maxCardWidth = 420.0;
  static const double _minCardHeight = 400.0;
  static const double _maxCardHeight = 560.0;

  @override
  void dispose() {
    _animController?.dispose();
    super.dispose();
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    if (_isAnimatingAway) return;
    _animController?.stop();
    _hasTriggeredHaptic = false;
    setState(() => _isSwiping = true);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_isAnimatingAway) return;
    setState(() {
      _dragOffset += Offset(details.delta.dx, 0);
    });

    if (!_hasTriggeredHaptic && _dragOffset.dx.abs() > _swipeThreshold) {
      _hasTriggeredHaptic = true;
      HapticFeedback.mediumImpact();
    }

    if (widget.onSwipeUpdate != null) {
      widget.onSwipeUpdate!(_swipeProgress, _isSwipingRight);
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_isAnimatingAway) return;

    final velocity = details.velocity.pixelsPerSecond.dx;
    final isFlick = velocity.abs() > 800;
    final pastThreshold = _dragOffset.dx.abs() > _swipeThreshold;

    if (pastThreshold || isFlick) {
      final isRight = isFlick ? velocity > 0 : _dragOffset.dx > 0;
      _animateFlyAway(isRight);
    } else {
      if (widget.onSwipeCancel != null) widget.onSwipeCancel!();
      _animateReturn();
    }
  }

  void _onHorizontalDragCancel() {
    if (_isAnimatingAway) return;
    if (widget.onSwipeCancel != null) widget.onSwipeCancel!();
    _animateReturn();
  }

  void _animateReturn() {
    _animController?.dispose();
    final startOffset = _dragOffset;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _offsetAnimation = Tween<Offset>(begin: startOffset, end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animController!, curve: Curves.easeOutCubic),
        );
    _animController!.addListener(() {
      if (mounted) setState(() => _dragOffset = _offsetAnimation!.value);
    });
    _animController!.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _isSwiping = false);
      }
    });
    _animController!.forward();
  }

  void _animateFlyAway(bool isRight) {
    _isAnimatingAway = true;
    HapticFeedback.lightImpact();
    final screenWidth = MediaQuery.of(context).size.width;
    final targetX = isRight ? screenWidth * 1.5 : -screenWidth * 1.5;

    _animController?.dispose();
    final startOffset = _dragOffset;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _offsetAnimation =
        Tween<Offset>(
          begin: startOffset,
          end: Offset(targetX, _dragOffset.dy * 0.3),
        ).animate(
          CurvedAnimation(parent: _animController!, curve: Curves.easeInCubic),
        );
    _animController!.addListener(() {
      if (mounted) setState(() => _dragOffset = _offsetAnimation!.value);
    });
    _animController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (isRight) {
          widget.onSwipeRight();
        } else {
          widget.onSwipeLeft();
        }
      }
    });
    _animController!.forward();
  }

  double get _rotation {
    final screenWidth = MediaQuery.of(context).size.width;
    return (_dragOffset.dx / screenWidth) * _maxRotation;
  }

  double get _swipeProgress {
    return (_dragOffset.dx.abs() / _swipeThreshold).clamp(0.0, 1.0);
  }

  double get _cardScale {
    return 1.0 - (_swipeProgress * 0.015);
  }

  bool get _isSwipingRight => _dragOffset.dx > 0;

  double _resolveCardHeight(BoxConstraints constraints, Size screenSize) {
    final availableHeight = constraints.maxHeight.isFinite
        ? constraints.maxHeight
        : screenSize.height * 0.62;
    final lowerBound = math.min(_minCardHeight, availableHeight);
    final upperBound = math.min(_maxCardHeight, availableHeight);
    final desiredHeight = availableHeight * 0.92;

    return desiredHeight.clamp(lowerBound, upperBound);
  }

  @override
  Widget build(BuildContext context) {
    final isSwipingRight = _dragOffset.dx > 0;
    final cs = Theme.of(context).colorScheme;
    final activeColor = isSwipingRight ? cs.success : cs.error;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = MediaQuery.sizeOf(context);
        final cardWidth = math.min(
          constraints.maxWidth.isFinite ? constraints.maxWidth : _maxCardWidth,
          _maxCardWidth,
        );
        final cardHeight = _resolveCardHeight(constraints, screenSize);

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: widget.onFlipTap,
          onHorizontalDragStart: _onHorizontalDragStart,
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          onHorizontalDragCancel: _onHorizontalDragCancel,
          child: Center(
            child: SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  // Static background slot — stays in place while card moves
                  if (_isSwiping && _swipeProgress > 0.06)
                    _buildBackgroundSlot(activeColor, cs),
                  // Moving card
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..translate(_dragOffset.dx, _dragOffset.dy)
                      ..rotateZ(_rotation)
                      ..scale(_cardScale),
                    child: Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.expand,
                      children: [
                        if (_isSwiping && _swipeProgress > 0.04)
                          _buildLiftShadow(activeColor, cs),
                        Positioned.fill(child: _buildCard(widget.isBookmarked, activeColor)),
                        if (_isSwiping && _swipeProgress > 0.06)
                          _buildDirectionOverlay(activeColor, cs),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLiftShadow(Color activeColor, ColorScheme cs) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: [
          BoxShadow(
            color: cs.fixedBlack.withValues(
              alpha: cs.learningSwipeLiftShadowAlpha,
            ),
            blurRadius: 30 + (_swipeProgress * 8),
            spreadRadius: -8,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: activeColor.withValues(
              alpha: _swipeProgress * cs.learningSwipeActiveShadowAlpha,
            ),
            blurRadius: 24,
            spreadRadius: -6,
            offset: Offset(_dragOffset.dx.sign * 8, 12),
          ),
        ],
      ),
    );
  }

  /// Background slot: if a next card exists, render its front face preview;
  /// otherwise show a plain shaped slot. Both scale up from the bottom as
  /// the swipe progresses to simulate a physical card stack.
  Widget _buildBackgroundSlot(Color color, ColorScheme cs) {
    final slotScale = 0.93 + (_swipeProgress * 0.07);
    final verticalOffset = 14.0 - (_swipeProgress * 14.0);
    final nextItem = widget.nextItem;

    return Positioned.fill(
      child: Transform(
        alignment: Alignment.bottomCenter,
        transform: Matrix4.identity()
          ..translate(0.0, verticalOffset)
          ..scale(slotScale),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_cardRadius),
            boxShadow: [
              BoxShadow(
                color: cs.fixedBlack.withValues(
                  alpha: cs.learningSwipeSlotPrimaryShadowAlpha,
                ),
                blurRadius: 18,
                spreadRadius: -2,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: cs.fixedBlack.withValues(
                  alpha: cs.learningSwipeSlotSecondaryShadowAlpha,
                ),
                blurRadius: 6,
                spreadRadius: 0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: nextItem != null
              ? _buildNextCardPreview(nextItem)
              : _buildEmptySlot(cs),
        ),
      ),
    );
  }

  /// Renders a non-interactive preview of the next card's front face.
  Widget _buildNextCardPreview(VocabularyItemModel nextItem) {
    return LearningCardShell(
      isBookmarked: false,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          nextItem.word,
          style: AppTheme.japaneseText.copyWith(
            fontSize: 52,
            fontWeight: FontWeight.w900,
            height: 1.1,
            letterSpacing: 2,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.85),
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  /// Fallback empty slot when there's no next card.
  Widget _buildEmptySlot(ColorScheme cs) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.learningSwipeEmptySlotSurface,
        borderRadius: BorderRadius.circular(_cardRadius),
      ),
      child: const SizedBox.expand(),
    );
  }

  Widget _buildDirectionOverlay(Color color, ColorScheme cs) {
    final overlayOpacity = _swipeProgress * cs.learningSwipeOverlayAlpha;
    final borderOpacity = (0.30 + (_swipeProgress * 0.50)).clamp(0.0, 0.80);
    final borderWidth = 2.0 + (_swipeProgress * 1.5);

    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: overlayOpacity),
          borderRadius: BorderRadius.circular(_cardRadius),
          border: Border.all(
            color: color.withValues(alpha: borderOpacity),
            width: borderWidth,
          ),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }

  Widget _buildCard(bool isBookmarked, Color activeColor) {
    final baseColor = Theme.of(context).colorScheme.primary;
    final stackedTopColor = _isSwiping && _swipeProgress > 0
        ? Color.lerp(baseColor, activeColor, _swipeProgress.clamp(0.0, 1.0)) ?? baseColor
        : baseColor;

    return widget.learningMode == CardStyle.recallMode.code
        ? RecallCardWidget(
            item: widget.item,
            isBookmarked: isBookmarked,
            flipController: widget.flipController,
            onSpeak: widget.onSpeak,
            onBookmarkToggle: widget.onBookmarkToggle,
            stackedTopColor: stackedTopColor,
          )
        : AbsorbCardWidget(
            item: widget.item,
            isBookmarked: isBookmarked,
            flipController: widget.flipController,
            onSpeak: widget.onSpeak,
            onBookmarkToggle: widget.onBookmarkToggle,
            stackedTopColor: stackedTopColor,
          );
  }
}
