import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';
import 'package:url_launcher/url_launcher.dart';

mixin Utility {
  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "";
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat("dd/MM/yyyy").format(dateTime);
    } catch (e) {
      return ""; // Return empty string if parsing fails
    }
  }

  void dismissKeyboard() => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

  Future<void> selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != DateTime.now()) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      controller.text = formattedDate;
    }
  }

  Widget imageWidget({
    required String imageUrl,
    required double width,
    required double height,
    BoxFit? fit,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: fit ?? BoxFit.fill,
          ),
        ),
      ),
      placeholder: (context, url) => SizedBox(
        width: width,
        height: height,
        child: Container(
          height: 180,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.greyColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: const Offset(1, 1),
                spreadRadius: 2.0,
                blurRadius: 2.0,
              )
            ],
          ),
        ),
      ),
      errorWidget: (context, url, error) =>
          ClipRRect(borderRadius: BorderRadius.circular(10), child: const TextWidget(text: "No Img Found !")),
    );
  }

  int calculateLastDigitOfSum(String input) {
    int sum = input.split('').map(int.parse).reduce((a, b) => a + b); // Sum of digits
    return sum % 10; // Extract the last digit of the sum
  }

  String getFormattedDate(String createdAt) {
    final DateTime createdDate = DateTime.parse(createdAt);
    final DateTime now = DateTime.now();
    final DateTime yesterday = now.subtract(const Duration(days: 1));

    if (createdDate.year == now.year && createdDate.month == now.month && createdDate.day == now.day) {
      return "Today";
    } else if (createdDate.year == yesterday.year &&
        createdDate.month == yesterday.month &&
        createdDate.day == yesterday.day) {
      return "Yesterday";
    } else {
      return DateFormat('dd MMM yyyy').format(createdDate);
    }
  }

  SizedBox heightBox5() => const SizedBox(
        height: 5,
      );

  SizedBox heightBox10() => const SizedBox(
        height: 10,
      );

  SizedBox heightBox15() => const SizedBox(
        height: 15,
      );

  SizedBox heightBox20() => const SizedBox(
        height: 20,
      );

  SizedBox heightBox30() => const SizedBox(
        height: 30,
      );

  SizedBox heightBox40() => const SizedBox(
        height: 40,
      );

  SizedBox heightBox50() => const SizedBox(
        height: 50,
      );

  SizedBox widthBox5() => const SizedBox(
        width: 5,
      );

  SizedBox widthBox10() => const SizedBox(
        width: 10,
      );

  SizedBox widthBox16() => const SizedBox(
        width: 16,
      );

  SizedBox widthBox20() => const SizedBox(
        width: 20,
      );

  SizedBox widthBox30() => const SizedBox(
        width: 30,
      );

  void showCustomDialog({
    BuildContext? context,
    String? title,
    String? message,
    required void Function()? onYesPressed,
    required void Function()? onNoPressed,
    bool? isLoading,
  }) {
    showDialog(
      context: context!,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: TextWidget(
              text: title ?? "",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ),
            content: TextWidget(
              text: message ?? "",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: onNoPressed,
                child: TextWidget(
                  text: 'No',
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                  ),
                ),
              ),
              isLoading ?? false
                  ? const CircularProgressIndicator()
                  : TextButton(
                      onPressed: onYesPressed,
                      child: TextWidget(
                        text: 'Yes',
                        style: GoogleFonts.poppins(
                          color: Colors.blue,
                        ),
                      ),
                    ),
            ],
          );
        });
      },
    );
  }

  Widget backButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.arrow_back,
            color: AppColors.blueColor,
          ),
          widthBox10(),
          const TextWidget(
            text: "Back",
            color: AppColors.blueColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget prefixIcon({required String? prefixAsset, Color? color}) {
    return Container(
      height: 50,
      width: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: const LinearGradient(
          colors: [
            Color(0XFFFBFCFE),
            Color(0XFFDAEEFE),
          ],
        ),
      ),
      child: SvgPicture.asset(
        prefixAsset ?? "",
        color: color ?? null,
      ),
    );
  }

  Widget svgAsset({required String assetName, Color? color, double? height, double? width}) {
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      color: color,
    );
  }

  Widget imageAsset(
      {required String assetPath, required BuildContext context, double? width, double? height, BoxFit? fit}) {
    return Image.asset(
      assetPath,
      width: width ?? MediaQuery.of(context).size.width,
      height: height ?? MediaQuery.of(context).size.height,
      fit: fit ?? null,
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(
            Icons.error,
            color: AppColors.blackColor,
          ),
        );
      },
    );
  }

  Widget buildDropdown(String label, String value, Function(String?) onChanged, List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E9E9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButton<String>(
        value: value,
        dropdownColor: Colors.white,
        focusColor: const Color(0xFFE9E9E9),
        isExpanded: true,
        underline: const SizedBox(),
        style: const TextStyle(color: Colors.black),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Future showOptions(BuildContext context, Function getImageFromGallery, Function getImageFromCamera) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const TextWidget(
              text: 'Photo Gallery',
            ),
            onPressed: () {
              Navigator.of(context).pop();
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const TextWidget(
              text: 'Camera',
            ),
            onPressed: () {
              getImageFromCamera();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  List<int> extractLastDigitOfSum(List digitList) {
    return digitList.map((digit) {
      final number = int.tryParse(digit) ?? 0;
      if (number >= 10) {
        return (number.toString().split('').map((e) => int.parse(e)).reduce((a, b) => a + b)) % 10;
      }
      return number;
    }).toList();
  }

  static List<String> subAdminPermission = [
    'Dashboard',
    'Movie',
    'Music',
    'Web Series',
    'Tv Show',
    'Live TV',
    'Short Film',
    'Ads',
    'Rentals',
    'Language',
    'Genre',
    'Users',
    'Sub Admin',
    'Subscription',
    'Reports',
    'Notification',
    'Settings'
  ];

  List<int> calculateOpenList(List openDigitList) {
    // Extract last digit of the sum for the open list
    return extractLastDigitOfSum(openDigitList);
  }

  List<int> calculateCloseList(List closeDigitList) {
    // Extract last digit of the sum for the close list
    return extractLastDigitOfSum(closeDigitList);
  }

  Future<void> launchCustomURL(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: "Unable to open the URL");
      print('Could not launch the URL: $url');
    }
  }

  List<String> calculateJodiList(List<int> openList, List<int> closeList) {
    List<String> jodiList = [];

    for (int i = 0; i < openList.length; i++) {
      var openDigit = openList[i];
      if (i < closeList.length) {
        var closeDigit = closeList[i];
        jodiList.add("$openDigit$closeDigit");
      } else {
        jodiList.add("$openDigit X");
      }
    }

    return jodiList;
  }
}
