import 'package:flutter/material.dart';

class SocialButtonWidget extends StatelessWidget {
  const SocialButtonWidget({super.key, required this.text, required this.onTap, this.radius});

  final String text;

  final VoidCallback onTap;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius ?? 10),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            text,
          ),
        ),
      ),
    );
  }
}
