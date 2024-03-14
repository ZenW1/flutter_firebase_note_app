import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:jong_jam/shared/constant/app_color.dart';

class GlobalOverLayWidget extends StatelessWidget {
  const GlobalOverLayWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayOpacity: 0.3,
      overlayColor: Colors.grey.withOpacity(0.3),
      overlayWidget: const Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: LoadingIndicator(
            indicatorType: Indicator.lineSpinFadeLoader,
            colors: [AppColors.primaryColor],
          ),
        ),
      ),
      child: child,
    );
  }
}
