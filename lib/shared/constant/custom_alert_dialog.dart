import 'package:flutter/material.dart';

import 'app_color.dart';
import 'button_widget.dart';
import 'dimensions.dart';

class CustomAlertDialogWidget extends StatelessWidget {
  const CustomAlertDialogWidget({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      insetPadding: EdgeInsets.all(Dimensions.paddingOverLarge()),
      backgroundColor: Colors.transparent,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Signing Out", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
            SizedBox(height: Dimensions.paddingSizeExtraSmall()),
            const Text("Are you sure you want to sign out?", style: TextStyle(fontSize: 14, color: Colors.black54)),
            SizedBox(height: Dimensions.paddingSizeSmall()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: ButtonWidget(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  backgroundColor: AppColors.bgColor,
                  text: 'No',
                  textColor: Colors.white,
                  // color: AppColors.primaryColor,
                )),
                Expanded(
                  child: ButtonWidget(
                    onTap: onTap,
                    text: 'Yes',
                    textColor: AppColors.primaryColor,
                    backgroundColor: AppColors.bgColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
