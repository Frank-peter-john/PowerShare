import 'package:flutter/material.dart';
import 'colors.dart';
import 'dimensions.dart';
import 'small_text.dart';

void showSnackBar(BuildContext context, String text) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: SmallText(
        text: text,
        color: whiteColor,
        size: Dimensions.font14,
      ),
      backgroundColor: isDark ? deepGreen : greenColor,
    ),
  );
}
