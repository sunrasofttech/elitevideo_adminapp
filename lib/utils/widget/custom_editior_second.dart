// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' as quill;
// import 'package:flutter_quill/flutter_quill.dart';
// import 'dart:convert';

// class CustomQuillEditor extends StatefulWidget {
//   final String? hint;
//   final String? htmlContent;
//   final void Function(String html)? onChanged;

//   const CustomQuillEditor({
//     super.key,
//     this.hint,
//     this.htmlContent,
//     this.onChanged,
//   });

//   @override
//   State<CustomQuillEditor> createState() => _CustomQuillEditorState();
// }

// class _CustomQuillEditorState extends State<CustomQuillEditor> {
//   late quill.QuillController _controller;

//   @override
//   void initState() {
//     super.initState();

//     if (widget.htmlContent != null && widget.htmlContent!.isNotEmpty) {
//       // final delta = QuillHtmlConverter.fromHtml(widget.htmlContent!);
//       // _controller = quill.QuillController(
//       //   document: quill.Document.fromDelta(delta),
//       //   selection: const TextSelection.collapsed(offset: 0),
//       // );
//     } else {
//       _controller = quill.QuillController.basic();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
      
//         Expanded(
//           child: quill.QuillEditor.basic(
//           controller: ,
//           config: ,

//           ),
//         ),
//         ElevatedButton(
//           onPressed: () {
          
//           },
//           child: const Text("Save HTML"),
//         ),
//       ],
//     );
//   }
// }
