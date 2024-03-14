import 'package:flutter/material.dart';

class CustomPageTransitionAnimation extends PageRouteBuilder {
  final Widget widget;
  final AxisDirection? direction;
  bool? isScaleAnimation;

  CustomPageTransitionAnimation(
      {required this.widget, required this.direction, this.isScaleAnimation = false})
      : super(
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation, Widget child) {
              animation = CurvedAnimation(parent: animation, curve: Curves.fastLinearToSlowEaseIn);
              return ScaleTransition(
                alignment: Alignment.center,
                scale: animation,
                child: child,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return widget;
            });

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return isScaleAnimation!
        ? _scaleAnimation(animation, child)
        : _sliderTransition(animation, child);
  }

  ScaleTransition _scaleAnimation(Animation<double> animation, Widget child) {
    animation = CurvedAnimation(parent: animation, curve: Curves.fastLinearToSlowEaseIn);
    return ScaleTransition(
      alignment: Alignment.center,
      scale: animation,
      child: child,
    );
  }

  SlideTransition _sliderTransition(Animation<double> animation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: getOffsetDirection(),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  Offset getOffsetDirection() {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.left:
        return const Offset(-1, 0);
      case AxisDirection.right:
        return const Offset(1, 0);
      default:
        return Offset.zero;
    }
  }
}
