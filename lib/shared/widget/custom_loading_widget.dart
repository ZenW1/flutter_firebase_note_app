import 'package:flutter/material.dart';
import 'package:jong_jam/shared/constant/app_color.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.flickr(leftDotColor: AppColors.primaryColor, rightDotColor: AppColors.bgColor, size:  50),
    );
  }
}
