import 'package:flutter/cupertino.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class CustomErrorWidget extends StatelessWidget with Utility {
  const CustomErrorWidget({super.key, this.error});
  final String? error;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                AppImages.errorJpg,
              ),
            ),
            heightBox20(),
            TextWidget(
              text: error ?? "Internal Server error",
            )
          ],
        ),
      ),
    );
  }
}
