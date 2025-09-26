import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showMessage(BuildContext context, String message) {
  if (Platform.isAndroid || Platform.isIOS) {
    Fluttertoast.showToast(msg: message);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
