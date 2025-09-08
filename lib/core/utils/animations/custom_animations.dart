import 'package:flutter/material.dart';

class CustomAnimations {
  static Widget slideFromBottom({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 100.0, end: 0.0),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget fadeIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeIn,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget scaleIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget slideFromLeft({
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -100.0, end: 0.0),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(value, 0),
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget slideFromRight({
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 100.0, end: 0.0),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(value, 0),
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget slideFromTop({
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -100.0, end: 0.0),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget staggeredList({
    required List<Widget> children,
    Duration initialDelay = const Duration(milliseconds: 100),
    Duration itemDelay = const Duration(milliseconds: 50),
  }) {
    return Column(
      children: List.generate(
        children.length,
        (index) => AnimatedBuilder(
          animation: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: const AlwaysStoppedAnimation(1),
              curve:const Interval(
                0.0,
                1.0,
                curve: Curves.easeOut,
              ),
            ),
          ),
          builder: (context, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent:const AlwaysStoppedAnimation(1),
                  curve:const Interval(
                    0.0,
                    1.0,
                    curve: Curves.easeOut,
                  ),
                ),
              ),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent:const AlwaysStoppedAnimation(1),
                    curve:const Interval(
                      0.0,
                      1.0,
                      curve: Curves.easeOut,
                    ),
                  ),
                ),
                child: children[index],
              ),
            );
          },
        ),
      ),
    );
  }
}
