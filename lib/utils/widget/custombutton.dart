import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final bool? inProgress;
  final int? progress;
  final double? buttonHeight;
  final double? buttonWidth;
  final Color? textColor;
  final double? borderRadius;

  const CustomOutlinedButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.inProgress,
    this.buttonHeight,
    this.progress,
    this.buttonWidth,
    this.textColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    log("message button  $progress");
    return Container(
      height: buttonHeight ?? 50.0,
      width: buttonWidth ?? double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.blueGradientList,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 12)),
        ),
        onPressed: onPressed,
        child: inProgress ?? false
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 20, height: 20, child: CustomCircularProgressIndicator()),
                  const SizedBox(width: 10),
                  Text(
                    progress != null ? "$progress%" : "Uploading...",
                    style: TextStyle(
                      color: textColor ?? AppColors.whiteColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ],
              )
            : TextWidget(
                text: buttonText,
                fontSize: 18,
                color: textColor ?? AppColors.whiteColor,
                fontWeight: FontWeight.w400,
              ),
      ),
    );
  }
}
