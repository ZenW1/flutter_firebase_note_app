import 'package:flutter/material.dart';
import 'package:jong_jam/main/view/home_page.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    Key? key,
    required this.title,
    required this.showButton,
    this.color,
    this.bottom,
    this.gradient,
    this.height,
    this.onTap,
  }) : super(key: key);

  final String title;
  final bool showButton;
  final Color? color;
  final PreferredSize? bottom;
  final Gradient? gradient;
  final double? height;
  final VoidCallback? onTap;

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      // backgroundColor: AppColors.bgColor,
      // flexibleSpace: Container(
      //   decoration: BoxDecoration(
      //     color: color ?? AppColors.bgColor,
      //     gradient: gradient,
      //   ),
      // ),
      leading: InkWell(
        onTap: onTap ??
            () {
              Navigator.of(context).pop();
            },
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
      ),
      actions: [
        showButton
            ? Row(
                children: [],
              )
            : Container(),
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 55);
}
