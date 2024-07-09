import 'package:flutter/material.dart';

onclickTextField(
    FocusNode node, TextEditingController controller, int clickCounted) {
  node.addListener(() {
    if (node.hasFocus && clickCounted == 0) {
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.text.length,
      );
    } else if (node.hasFocus && clickCounted > 1) {
      controller.selection =
          TextSelection.collapsed(offset: controller.text.length);
    } else {
      clickCounted = 0;
    }
  });
}
