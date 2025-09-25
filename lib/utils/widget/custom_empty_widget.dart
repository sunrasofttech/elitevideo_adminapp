import 'package:flutter/widgets.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

class CustomEmptyWidget extends StatelessWidget {
  const CustomEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          noDataImg,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
