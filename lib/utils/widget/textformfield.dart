import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/color.dart';

// ignore: must_be_immutable
class TextFormFieldWidget extends StatefulWidget {
  TextFormFieldWidget({
    super.key,
    this.hintText,
    this.height,
    this.rounded = 5.0,
    this.fontWeight,
    this.focusNode,
    this.suffixIcon,
    this.isSuffixIconShow = false,
    this.isRounded = true,
    this.backgroundColor,
    this.controller,
    this.keyboardType,
    this.inputFormater,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.isBorderColor = true,
    this.obscureText,
    this.hintTextColor,
    this.textColor,
    this.onTap,
    this.textAlignVertical,
    this.fontSize,
    this.maxLine,
    this.minLines,
    this.decoration,
    this.contentPadding = 10,
    this.prefixIcon,
    this.showPrefix = false,

    this.borderColor,
    this.readOnly = false,
    this.enabled = true,
  });

  final String? initialValue;
  final String? hintText;
  final int? maxLine;
  final int? minLines;
  final bool isSuffixIconShow;
  final double? height;
  final double rounded;
  final bool isRounded;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? backgroundColor;
  final Color? hintTextColor;
  final Color? textColor;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormater;
  final bool? isBorderColor;
  final bool? obscureText;
  final TextAlignVertical? textAlignVertical;
  final Function(String)? onChanged;
  void Function()? onTap;
  final String? Function(String?)? validator;
  final InputDecoration? decoration;
  final Widget? prefixIcon;
  final bool showPrefix;
  final double contentPadding;
  final Color? borderColor;
  final bool readOnly;
 final bool enabled;
  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.isRounded ? BorderRadius.circular(widget.rounded) : null,
      ),
      height: widget.height,
      child: TextFormField(
        onTap: widget.onTap,
        maxLines: widget.maxLine ?? 1,
        minLines: widget.minLines,
        obscureText: widget.obscureText ?? false,
        initialValue: widget.initialValue,
        inputFormatters: widget.inputFormater,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        cursorColor: AppColors.blackColor,
        readOnly: widget.readOnly,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        validator: widget.validator,
        textAlignVertical: widget.textAlignVertical,
        style: GoogleFonts.kumbhSans(
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          color: widget.textColor,
        ),
        decoration: widget.decoration ??
            InputDecoration(
              contentPadding: EdgeInsets.all(
                widget.contentPadding,
              ),
              prefixIcon: widget.showPrefix
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      child: widget.prefixIcon,
                    )
                  : null,
                  enabled: widget.enabled,
              hintText: widget.hintText,
              hintStyle: GoogleFonts.kumbhSans(
                fontSize: widget.fontSize,
                fontWeight: widget.fontWeight,
                color: widget.hintTextColor,
              ),
              suffixIcon: widget.suffixIcon,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.rounded,
                ),
                borderSide: BorderSide(
                  width: 1,
                  color: widget.borderColor ?? AppColors.greyColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.rounded),
                borderSide: BorderSide(
                  width: 1,
                  color: widget.borderColor ?? AppColors.greyColor,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.rounded),
                borderSide: BorderSide(
                  width: 1,
                  color: widget.borderColor ?? AppColors.greyColor,
                ),
              ),
            ),
      ),
    );
  }
}
