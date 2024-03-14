import 'package:flutter/material.dart';
import 'package:jong_jam/shared/constant/app_color.dart';
import 'package:showcaseview/showcaseview.dart';

class CustomShowCaseWidget extends StatelessWidget {
  CustomShowCaseWidget(
      {super.key,
      required this.keys,
      required this.description,
      required this.child,
      this.disposeOnTap,
      this.onTargetClick});

  final GlobalKey<State> keys;
  final String description;
  final Widget child;
  final VoidCallback? onTargetClick;
  bool? disposeOnTap = false;

  @override
  Widget build(BuildContext context) {
    return Showcase(
      textColor: AppColors.bgColor,
      blurValue: 1,
      overlayOpacity: 0.5,
      overlayColor: Colors.white,
      onTargetClick: onTargetClick,
      titleTextStyle: const TextStyle(
        color: AppColors.bgColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      disposeOnTap: disposeOnTap,
      key: keys,
      description: description,
      child: child,
    );
  }
}
