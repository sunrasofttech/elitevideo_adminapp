import 'dart:io';

import 'package:elite_admin/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:html/parser.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elite_admin/bloc/setting/get_setting/get_setting_cubit.dart';
import 'package:elite_admin/bloc/setting/update_setting/update_setting_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image_picker_utils.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_dropdown.dart';
import 'package:elite_admin/utils/widget/custom_editor.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> with Utility {
  XFile? _selectedImage;
  final HtmlEditorController _termAndCondController = HtmlEditorController();
  final HtmlEditorController _privacyController = HtmlEditorController();
  final HtmlEditorController _aboutUsController = HtmlEditorController();
  final HtmlEditorController _helpAndSupportController = HtmlEditorController();
  final TextEditingController appNameController = TextEditingController();
  final TextEditingController appVersionController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final playStoreLinkController = TextEditingController();
  final developedByController = TextEditingController();
  XFile? _splashImage1;
  XFile? _splashImage2;
  XFile? _splashImage3;
  bool isSongOnSubscription = false;
  final TextEditingController razorpayKey = TextEditingController();
  final TextEditingController phonepayKey = TextEditingController();
  final TextEditingController phonepayPaySaltKey = TextEditingController();
  final TextEditingController cashfreeClientSecretKey = TextEditingController();
  final TextEditingController cashfreeClientId = TextEditingController();
  final TextEditingController secrectKey = TextEditingController();
  final TextEditingController requiredVersion = TextEditingController();

  String? selectedPaymentType;
  List<String> paymentType = ['UPI', 'RazorPay', 'Cashfree', 'PhonePe', 'SkillPay', 'NoGateway', 'Free', 'ABC'];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePickerUtil.pickImageFromGallery(
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  Future<void> _pickSplashImage(int index) async {
    final pickedFile = await ImagePickerUtil.pickImageFromGallery(
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
    );
    if (pickedFile != null) {
      setState(() {
        switch (index) {
          case 1:
            _splashImage1 = pickedFile;
            break;
          case 2:
            _splashImage2 = pickedFile;
            break;
          case 3:
            _splashImage3 = pickedFile;
            break;
        }
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    contactController.dispose();
    appVersionController.dispose();
    appNameController.dispose();
    playStoreLinkController.dispose();
    developedByController.dispose();
    razorpayKey.dispose();
    phonepayPaySaltKey.dispose();
    phonepayKey.dispose();
    cashfreeClientSecretKey.dispose();
    cashfreeClientId.dispose();
    secrectKey.dispose();
    requiredVersion.dispose();
    super.dispose();
  }

  @override
  void initState() {
    context.read<GetSettingCubit>().getSetting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<GetSettingCubit>().getSetting();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: BlocConsumer<GetSettingCubit, GetSettingState>(
              listener: (context, state) {
                if (state is GetSettingLoadedState) {
                  appNameController.text = "OTT";
                  appVersionController.text = state.model.setting?.currentVersion ?? "";
                  emailController.text = state.model.setting?.adminEmail ?? "";
                  contactController.text = state.model.setting?.adminContactNo ?? "";
                  developedByController.text = state.model.setting?.developedBy ?? "";
                  playStoreLinkController.text = state.model.setting?.playStoreLink ?? "";
                  razorpayKey.text = state.model.setting?.razorpayKey ?? "";
                  secrectKey.text = state.model.setting?.secretKey ?? "";
                  phonepayKey.text = state.model.setting?.phonepayKey ?? "";
                  requiredVersion.text = state.model.setting?.requiredVersion ?? "";
                  phonepayPaySaltKey.text = state.model.setting?.phonepayPaySaltKey ?? "";
                  cashfreeClientId.text = state.model.setting?.cashfreeClientId ?? "";
                  cashfreeClientSecretKey.text = state.model.setting?.cashfreeClientSecretKey ?? '';
                  selectedPaymentType = state.model.setting?.paymentType;
                  isSongOnSubscription = state.model.setting?.isSongOnSubscription ?? false;
                }
              },
              builder: (context, state) {
                if (state is GetSettingLoadingState) {
                  return const Center(child: CustomCircularProgressIndicator());
                }
                if (state is GetSettingLoadedState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextWidget(text: "App Setting", fontWeight: FontWeight.w500, fontSize: 17),
                      heightBox15(),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.whiteColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextWidget(text: "App Logo"),
                            heightBox10(),
                            GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  border: Border.all(color: AppColors.greyColor),
                                ),
                                child: _selectedImage == null
                                    ? Column(
                                        children: [
                                          SvgPicture.asset("asset/svg/profile-circle.svg"),
                                          heightBox10(),
                                          const TextWidget(text: "Select a profile picture"),
                                          const TextWidget(text: "Browse or Drag image here.."),
                                        ],
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(_selectedImage!.path),
                                          width: double.infinity,
                                          height: 190,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      heightBox15(),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.whiteColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextWidget(text: "App Name"),
                            heightBox10(),
                            TextFormFieldWidget(controller: appNameController),
                            heightBox15(),
                            const TextWidget(text: "App Version"),
                            heightBox10(),
                            TextFormFieldWidget(controller: appVersionController),
                            heightBox15(),
                            const TextWidget(text: "App Required Version"),
                            heightBox10(),
                            TextFormFieldWidget(controller: requiredVersion),
                            heightBox15(),
                            const TextWidget(text: "Selected Payment Type"),
                            heightBox10(),
                            CustomDropdown(
                              items: paymentType,
                              selectedValue: selectedPaymentType,
                              onChanged: (value) {
                                setState(() {
                                  selectedPaymentType = value;
                                });
                              },
                            ),
                            heightBox15(),
                            const TextWidget(text: "Email"),
                            heightBox10(),
                            TextFormFieldWidget(controller: emailController),
                            heightBox15(),
                            const TextWidget(text: "Contact"),
                            heightBox10(),
                            TextFormFieldWidget(controller: contactController),
                            heightBox15(),
                            const TextWidget(text: "PlayStore Link"),
                            heightBox10(),
                            TextFormFieldWidget(controller: playStoreLinkController),
                            heightBox15(),
                            const TextWidget(text: "Developed By"),
                            heightBox10(),
                            TextFormFieldWidget(controller: developedByController),
                            heightBox15(),
                            const TextWidget(text: "Razorpay Key"),
                            heightBox10(),
                            TextFormFieldWidget(controller: razorpayKey),
                            heightBox15(),
                            const TextWidget(text: "Razorpay Secret Key"),
                            heightBox10(),
                            TextFormFieldWidget(controller: secrectKey),
                            heightBox15(),
                            const TextWidget(text: "Phone Pay Key"),
                            heightBox10(),
                            TextFormFieldWidget(controller: phonepayKey),
                            heightBox15(),
                            const TextWidget(text: "Phone Pay Salt Key"),
                            heightBox10(),
                            TextFormFieldWidget(controller: phonepayPaySaltKey),
                            heightBox15(),
                            const TextWidget(text: "Cashfree Client Id"),
                            heightBox10(),
                            TextFormFieldWidget(controller: cashfreeClientId),
                            heightBox15(),
                            const TextWidget(text: "Cashfree Client Secret Key"),
                            heightBox10(),
                            TextFormFieldWidget(controller: cashfreeClientSecretKey),
                            heightBox15(),
                            const TextWidget(text: "Splash Screen 1"),
                            heightBox10(),
                            GestureDetector(
                              onTap: () {
                                _pickSplashImage(1);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  border: Border.all(color: AppColors.greyColor),
                                ),
                                child: _splashImage1 == null
                                    ? Column(
                                        children: [
                                          SvgPicture.asset("asset/svg/profile-circle.svg"),
                                          heightBox10(),
                                          const TextWidget(text: "Select a Splash Screen"),
                                          const TextWidget(text: "Browse or Drag image here.."),
                                        ],
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(_splashImage1!.path),
                                          width: double.infinity,
                                          height: 190,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            ),
                            heightBox15(),
                            const TextWidget(text: "Splash Screen 2"),
                            heightBox10(),
                            GestureDetector(
                              onTap: () {
                                _pickSplashImage(2);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  border: Border.all(color: AppColors.greyColor),
                                ),
                                child: _splashImage2 == null
                                    ? Column(
                                        children: [
                                          SvgPicture.asset("asset/svg/profile-circle.svg"),
                                          heightBox10(),
                                          const TextWidget(text: "Select a Splash Screen"),
                                          const TextWidget(text: "Browse or Drag image here.."),
                                        ],
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(_splashImage2!.path),
                                          width: double.infinity,
                                          height: 190,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            ),
                            heightBox15(),
                            const TextWidget(text: "Splash Screen 3"),
                            heightBox10(),
                            GestureDetector(
                              onTap: () {
                                _pickSplashImage(3);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  border: Border.all(color: AppColors.greyColor),
                                ),
                                child: _splashImage3 == null
                                    ? Column(
                                        children: [
                                          SvgPicture.asset("asset/svg/profile-circle.svg"),
                                          heightBox10(),
                                          const TextWidget(text: "Select a Splash Screen"),
                                          const TextWidget(text: "Browse or Drag image here.."),
                                        ],
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(_splashImage3!.path),
                                          width: double.infinity,
                                          height: 190,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            ),
                            heightBox15(),
                            const TextWidget(text: "About Us"),
                            heightBox10(),
                            SizedBox(
                              height: 600,
                              child: CustomHtmlEditor(
                                hint: state.model.setting?.aboutUs ?? "",
                                htmlContent: state.model.setting?.aboutUs ?? "",
                                onPressed: () {},
                                controller: _aboutUsController,
                              ),
                            ),
                            heightBox15(),
                            const TextWidget(text: "Privacy Policy"),
                            heightBox10(),
                            SizedBox(
                              height: 600,
                              child: CustomHtmlEditor(
                                hint: state.model.setting?.privacyPolicy ?? "",
                                htmlContent: state.model.setting?.privacyPolicy ?? "",
                                onPressed: () {},
                                controller: _privacyController,
                              ),
                            ),
                            heightBox15(),
                            const TextWidget(text: "Term and Conditions"),
                            heightBox10(),
                            SizedBox(
                              height: 600,
                              child: CustomHtmlEditor(
                                hint: state.model.setting?.termsAndCondition ?? "",
                                htmlContent: state.model.setting?.termsAndCondition ?? "",
                                onPressed: () {},
                                controller: _termAndCondController,
                              ),
                            ),
                            heightBox15(),
                            const TextWidget(text: "Help And Support"),
                            heightBox10(),
                            SizedBox(
                              height: 600,
                              child: CustomHtmlEditor(
                                hint: state.model.setting?.helpSupport ?? "",
                                htmlContent: state.model.setting?.helpSupport ?? "",
                                onPressed: () {},
                                controller: _helpAndSupportController,
                              ),
                            ),
                            heightBox15(),
                            const TextWidget(text: "Show Subscription On Music"),
                            heightBox10(),
                            Switch(
                              activeColor: Colors.greenAccent,
                              value: isSongOnSubscription,
                              onChanged: (value) {
                                isSongOnSubscription = value;
                                setState(() {});
                              },
                            ),
                            heightBox15(),
                            BlocConsumer<UpdateSettingCubit, UpdateSettingState>(
                              listener: (context, state) {
                                if (state is UpdateSettingErrorState) {
                                  showMessage(context, state.error);
                                  return;
                                }

                                if (state is UpdateSettingLoadedState) {
                                  showMessage(context, "Update Successfully");
                                  context.read<GetSettingCubit>().getSetting();
                                }
                              },
                              builder: (context, updateState) {
                                return CustomOutlinedButton(
                                  inProgress: (updateState is UpdateSettingLoadingState),
                                  onPressed: () async {
                                    final aboutcontentData = await _aboutUsController.getText();
                                    final document = parse(aboutcontentData);
                                    final aboutUsControllerText = document.outerHtml;

                                    final privacycontentData = await _privacyController.getText();
                                    final privacydocument = parse(privacycontentData);
                                    final privacyControllerText = privacydocument.outerHtml;

                                    final termContentData = await _termAndCondController.getText();
                                    final termDocument = parse(termContentData);
                                    final termControllerText = termDocument.outerHtml;

                                    final helpContentData = await _helpAndSupportController.getText();
                                    final helpDocument = parse(helpContentData);
                                    final helpControllerText = helpDocument.outerHtml;

                                    context.read<UpdateSettingCubit>().updateSetting(
                                      id: state.model.setting?.id ?? "",
                                      aboutUs: aboutUsControllerText,
                                      privacyPolicy: privacyControllerText,
                                      termsAndCondition: termControllerText,
                                      adminContactNumber: contactController.text,
                                      adminEmail: emailController.text,
                                      currentVersion: appVersionController.text,
                                      developedBy: developedByController.text,
                                      helpSupport: helpControllerText,
                                      spashScreenBanner1: _splashImage1 != null ? File(_splashImage1!.path) : null,
                                      spashScreenBanner2: _splashImage2 != null ? File(_splashImage2!.path) : null,
                                      spashScreenBanner3: _splashImage3 != null ? File(_splashImage3!.path) : null,
                                      cashfreeClientId: cashfreeClientId.text,
                                      cashfreeClientSecretKey: cashfreeClientSecretKey.text,
                                      paymentType: selectedPaymentType,
                                      secretKey: secrectKey.text,
                                      requiredVersion: requiredVersion.text,
                                      phonepayKey: phonepayKey.text,
                                      phonepayPaySaltKey: phonepayPaySaltKey.text,
                                      playStoreLink: playStoreLinkController.text,
                                      razorpayKey: razorpayKey.text,
                                      isSongOnSubscription: isSongOnSubscription,
                                    );
                                  },
                                  buttonText: 'Save',
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}
