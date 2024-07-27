import 'package:flutter/material.dart';
import 'package:projectx/values/app_colors.dart';

// defines all the textstyles used in the project

const logo = TextStyle(fontWeight: FontWeight.bold, color: Colors.white);
const headersDashboard = TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0);
const amountHeader =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0, color: Colors.white);
final headerWhite =
    TextStyle(fontWeight: FontWeight.bold, color: AppColors.whiteText);
final headerBlackSmall = blackHeaders(14.0);
final headerBlackMedium = blackHeaders(17.0);
final headerBlackLarge = blackHeaders(25.0);
const hintText = TextStyle(color: Colors.grey);

TextStyle blackHeaders(double size) {
  return TextStyle(
      fontWeight: FontWeight.bold, color: AppColors.blackText, fontSize: size);
}
