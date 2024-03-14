import 'package:flutter/material.dart';

import 'app_color.dart';

class ButtonWidget extends StatelessWidget {
  ButtonWidget({
    Key? key,
    required this.onTap,
    required this.text,
    this.width,
    this.gradient,
    this.color,
    this.textColor,
    this.backgroundColor,
  }) : super(key: key);

  final VoidCallback onTap;
  final String text;
  double? width;
  Gradient? gradient;
  Color? backgroundColor;
  Color? color;

  Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: width,
      height: MediaQuery.of(context).size.height * 0.055,
      decoration: BoxDecoration(
        gradient: gradient,
        color: backgroundColor ?? AppColors.primaryColor,
        borderRadius: BorderRadius.circular(200),
      ),
      child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: color ?? Colors.transparent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(200),
            ),
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
          ),
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: textColor ?? Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
          )),
    );
  }
}
