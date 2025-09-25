import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elite_admin/constant/color.dart';

class CustomTextStyle {
  static TextStyle headingTextStyle = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
  );

  static TextStyle secondaryTextStyle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.blackColor,
  );

  static TextStyle greyTextStyle = GoogleFonts.poppins(
    fontSize: 16,
    color: AppColors.blackColor,
    fontWeight: FontWeight.w300,
  );
}
