import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/app_color.dart';

class GlobalTextField extends StatefulWidget {
  GlobalTextField(
      {Key? key,
      required this.textInputType,
      required this.controller,
      required this.hintText,
      this.contentPadding,
      this.filled,
      this.validator,
      this.labelText,
      this.onChanged,
      this.maxLines,
      this.inputFormatter,
      this.labelColor,
      this.onSaved,
      this.onTap,
      this.focusNode,
      this.obSecureText,
      this.onSubmitted,
      this.suffixIcon,
      this.prefixIcon,
      this.readOnly,
      this.suffixIconColor,
      this.prefixIconColor,
      this.hintStyle,
      this.labelStyle,
      this.style})
      : super(key: key);

  final TextInputType textInputType;
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final Function(String)? onSubmitted;
  final TextInputFormatter? inputFormatter;
  final Color? labelColor;
  final int? maxLines;
  final Function(String?)? onSaved;
  Function(String)? onChanged;
  VoidCallback? onTap;
  bool? readOnly;
  FocusNode? focusNode;
  TextStyle? style;
  TextStyle? labelStyle;
  TextStyle? hintStyle;
  Color? suffixIconColor;
  Color? prefixIconColor;
  Widget? suffixIcon;
  Widget? prefixIcon;
  bool? filled;
  bool? obSecureText;
  EdgeInsetsGeometry? contentPadding;
  String? labelText;

  @override
  State<GlobalTextField> createState() => _GlobalTextFieldState();
}

class _GlobalTextFieldState extends State<GlobalTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.key,
      validator: widget.validator,
      keyboardType: widget.textInputType,
      controller: widget.controller,
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
      },
      readOnly: widget.onTap == null ? false : true,
      textDirection: TextDirection.ltr,
      onFieldSubmitted: widget.onSubmitted,
      textInputAction: TextInputAction.done,
      maxLines: widget.maxLines ?? 1,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      focusNode: widget.focusNode,
      onTap: widget.onTap,
      obscureText: widget.obSecureText ?? false,
      obscuringCharacter: '*',
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: widget.style,
      decoration: InputDecoration(
        counterStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
            ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 0.5,
            )
            // borderSide: BorderSide.none,
            ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 0.5,
            )
            // borderSide: BorderSide.none,
            ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 0.5,
            )
            // borderSide: BorderSide.none,
            ),
        suffixIcon: widget.suffixIcon,
        suffixIconColor: widget.suffixIconColor,
        prefixIconColor: widget.prefixIconColor,
        prefixIcon: widget.prefixIcon,
        hintText: widget.hintText,
        // hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
        //   fontSize: 14,
        //   fontWeight: FontWeight.w500,
        //   color: AppColors.primaryColor,
        // ),
        hintStyle: widget.hintStyle,
        labelText: widget.labelText,
        labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: widget.labelColor ?? AppColors.primaryColor,
            ),
        // labelStyle: widget.labelStyle,
        fillColor: Colors.white,
        filled: widget.filled,
        contentPadding: widget.contentPadding ?? const EdgeInsets.all(15),
      ),
      enabled: true,
    );
  }
}
