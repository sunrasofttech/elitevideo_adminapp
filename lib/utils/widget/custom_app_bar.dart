import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/presentation/auth/login_screen.dart';
import 'package:elite_admin/presentation/auth/profile.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

import '../preferences/local_preferences.dart';

class CustomAppBar extends StatelessWidget with Utility {
  const CustomAppBar({
    super.key,
    this.text,
    required this.leading,
    this.notificationOnTap,
    required this.settingOnTap,
  });
  final String? text;
  final Widget? leading;
  final void Function()? notificationOnTap;
  final void Function()? settingOnTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      leading: leading ?? const SizedBox(),
      leadingWidth: 40,
      actions: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            color: Color.fromRGBO(150, 150, 150, 0.23),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                AppImages.notificationSvg,
                color: AppColors.greyColor,
              ),
              widthBox10(),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'profile') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  } else if (value == 'logout') {
                    await LocalStorageUtils.clear().then((e) => {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          )
                        });
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'profile',
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "asset/svg/profile-circle.svg",
                          height: 25,
                          color: AppColors.blackColor,
                          width: 25,
                        ),
                        widthBox10(),
                        const TextWidget(text: 'Profile'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "asset/svg/logout.svg",
                          height: 25,
                          color: AppColors.blackColor,
                          width: 25,
                        ),
                        widthBox10(),
                        const TextWidget(text: 'Logout'),
                      ],
                    ),
                  ),
                ],
                child: const CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        widthBox10(),
      ],
    );
  }
}
