import 'package:flutter/material.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

void openConfirmationDialog({
  required context,
  required title,
  required message,
  required color,
  required positiveButtonText,
  required negativeButtonText,
  widget,
  required void Function()? onPositiveButtonClick,
  required void Function()? onNegativeButtonClick,
}) {
  var alertDialog = ConfirmationDialog(
    context: context,
    widget: widget,
    title: title,
    message: message,
    color: color,
    positiveButtonText: positiveButtonText,
    negativeButtonText: negativeButtonText,
    onPositiveButtonClick: onPositiveButtonClick,
    onNegativeButtonClick: onNegativeButtonClick,
  );
  showDialog(context: context, builder: (context) => alertDialog);
}

class ConfirmationDialog extends StatelessWidget with Utility {
  const ConfirmationDialog({
    super.key,
    required this.context,
    required this.title,
    required this.message,
    this.color,
    this.widget,
    required this.positiveButtonText,
    required this.negativeButtonText,
    required this.onPositiveButtonClick,
    required this.onNegativeButtonClick,
  });

  final BuildContext context;
  final String title;
  final String message;
  final Color? color;
  final String positiveButtonText;
  final Widget? widget;
  final String negativeButtonText;
  final void Function()? onPositiveButtonClick;
  final void Function()? onNegativeButtonClick;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      elevation: 16,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget(
              text: title,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
              fontSize: 17,
            ),
            heightBox10(),
            TextWidget(
              text: message,
              fontSize: 14,
              color: AppColors.blackColor,
            ),
            heightBox10(),
            widget ?? const SizedBox(),
            heightBox20(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: onNegativeButtonClick,
                  child: Container(
                    width: 70,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: TextWidget(
                        text: negativeButtonText,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                widthBox10(),
                InkWell(
                  onTap: onPositiveButtonClick,
                  child: Container(
                    width: 100,
                    height: 35,
                    decoration: BoxDecoration(
                      color: color ?? Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: TextWidget(
                        text: positiveButtonText,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
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
