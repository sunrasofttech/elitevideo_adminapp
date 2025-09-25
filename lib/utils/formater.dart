import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimeTextInputFormatter extends TextInputFormatter {
  String _formatToMMSS(String input) {
    input = input.replaceAll(RegExp(r'\D'), '');
    input = input.padLeft(4, '0');
    final minutes = input.substring(0, 2);
    final seconds = input.substring(2, 4);
    return '$minutes:$seconds';
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 4) {
      digits = digits.substring(0, 4);
    }

    final formatted = _formatToMMSS(digits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

