import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  const LikeAnimation(
      {super.key,
      required this.child,
      required this.isAnimating,
      this.duration = const Duration(milliseconds: 150),
      this.onEnd,
      this.smallLike = false});

  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLike;

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
    );
    _scale = Tween<double>(begin: 1, end: 1.2).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimating();
    }
  }

  startAnimating() async {
    if (widget.isAnimating || widget.smallLike) {
      await _controller.forward();
      await _controller.reverse();
      await Future.delayed(const Duration(milliseconds: 200));

      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: widget.child,
    );
  }
}
