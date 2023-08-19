import 'package:flutter/material.dart';
import 'big_text.dart';
import 'colors.dart';
import 'dimensions.dart';

class PowerShareHeading extends StatelessWidget {
  const PowerShareHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return BigText(
      text: 'PowerShare',
      size: Dimensions.font30,
      color: greenColor,
    );
  }
}
