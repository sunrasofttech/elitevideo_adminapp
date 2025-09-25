import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:elite_admin/utils/utility_mixin.dart';

class CustomHtmlEditor extends StatelessWidget with Utility {
  final String? hint;
  final void Function()? onPressed;
  final HtmlEditorController controller;
  final String? title;
  final String? htmlContent;

  const CustomHtmlEditor({
    super.key,
    required this.hint,
    required this.onPressed,
    required this.controller,
    this.htmlContent,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return HtmlEditor(
      otherOptions: OtherOptions(
        height: MediaQuery.of(context).size.height * 0.7,
      ),
      controller: controller,
      htmlEditorOptions: HtmlEditorOptions(
        hint: hint,
        initialText: null,
        spellCheck: true,
      ),
      htmlToolbarOptions: HtmlToolbarOptions(
        
        allowImagePicking: false,
        buttonColor: Theme.of(context).highlightColor,
        dropdownIconColor: Theme.of(context).highlightColor,
        dropdownBoxDecoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
        ),
        toolbarType: ToolbarType.nativeGrid,
      ),
      callbacks: Callbacks(
        onEnter: () {
          log("message 1111111111111111111111111111");
        },
        onInit: () {
          controller.setText(htmlContent.toString());
        },
      ),
    );
  }
}
