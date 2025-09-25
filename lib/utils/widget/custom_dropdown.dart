import 'package:flutter/material.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String? hinttext;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.selectedValue,
    this.hinttext,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          borderRadius: BorderRadius.circular(12),
          isExpanded: true,
          hint: hinttext != null
              ? TextWidget(
                  text: hinttext!,
                  color: AppColors.greyColor,
                )
              : null,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          value: items.contains(selectedValue) ? selectedValue : null,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }
}
