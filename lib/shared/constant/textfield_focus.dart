import 'package:flutter/material.dart';

extension TextFieldFocus on BuildContext {
  void nextFocus(FocusNode currentFocusNode, FocusNode nextFocusNode) {
    currentFocusNode.unfocus();
    FocusScope.of(this).requestFocus(nextFocusNode);
  }
}
