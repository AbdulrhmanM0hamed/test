import 'package:flutter/material.dart';

class AddToCartAnimation extends StatefulWidget {
  final Widget child;
  final GlobalKey cartIconKey;
  final VoidCallback? onAnimationComplete;

  const AddToCartAnimation({
    super.key,
    required this.child,
    required this.cartIconKey,
    this.onAnimationComplete,
  });

  @override
  State<AddToCartAnimation> createState() => _AddToCartAnimationState();
}

class _AddToCartAnimationState extends State<AddToCartAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    _positionAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, -200), // Will be calculated dynamically
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
          ),
        );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startAnimation() {
    _calculateCartPosition();
    _controller.forward();
  }

  void _calculateCartPosition() {
    final RenderBox? cartRenderBox =
        widget.cartIconKey.currentContext?.findRenderObject() as RenderBox?;

    if (cartRenderBox != null) {
      final cartPosition = cartRenderBox.localToGlobal(Offset.zero);
      final currentContext = context;
      final RenderBox? currentRenderBox =
          currentContext.findRenderObject() as RenderBox?;

      if (currentRenderBox != null) {
        final currentPosition = currentRenderBox.localToGlobal(Offset.zero);
        final deltaX = cartPosition.dx - currentPosition.dx;
        final deltaY = cartPosition.dy - currentPosition.dy;

        _positionAnimation =
            Tween<Offset>(
              begin: Offset.zero,
              end: Offset(
                deltaX / 100,
                deltaY / 100,
              ), // Scale down for smooth animation
            ).animate(
              CurvedAnimation(
                parent: _controller,
                curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _positionAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(opacity: _fadeAnimation.value, child: widget.child),
          ),
        );
      },
    );
  }
}

class CartAnimationOverlay extends StatefulWidget {
  static final GlobalKey<_CartAnimationOverlayState> _key =
      GlobalKey<_CartAnimationOverlayState>();

  CartAnimationOverlay({Key? key}) : super(key: _key);

  static void showAnimation({
    required BuildContext context,
    required Widget animatingWidget,
    required GlobalKey cartIconKey,
    VoidCallback? onComplete,
  }) {
    _key.currentState?.showAnimation(
      context: context,
      animatingWidget: animatingWidget,
      cartIconKey: cartIconKey,
      onComplete: onComplete,
    );
  }

  @override
  State<CartAnimationOverlay> createState() => _CartAnimationOverlayState();
}

class _CartAnimationOverlayState extends State<CartAnimationOverlay>
    with TickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _controller.dispose();
    super.dispose();
  }

  void showAnimation({
    required BuildContext context,
    required Widget animatingWidget,
    required GlobalKey cartIconKey,
    VoidCallback? onComplete,
  }) {
    _removeExistingOverlay();

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy,
        width: size.width,
        height: size.height,
        child: IgnorePointer(
          child: AddToCartAnimation(
            cartIconKey: cartIconKey,
            onAnimationComplete: () {
              _removeExistingOverlay();
              onComplete?.call();
            },
            child: animatingWidget,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      final animationState =
          (_overlayEntry?.builder(context) as Positioned).child
              as IgnorePointer;
      final addToCartAnimation = animationState.child as AddToCartAnimation;
      (addToCartAnimation.createState() as _AddToCartAnimationState)
          .startAnimation();
    });
  }

  void _removeExistingOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
