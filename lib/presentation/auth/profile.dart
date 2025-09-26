import 'dart:io';
import 'package:elite_admin/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elite_admin/bloc/auth/get_profile/get_profile_cubit.dart';
import 'package:elite_admin/bloc/auth/update_profile/update_profile_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image_picker_utils.dart';
import 'package:elite_admin/main.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with Utility {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? role;
  XFile? _selectedImage;

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

  @override
  void initState() {
    context.read<GetProfileCubit>().getProfile(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetProfileCubit, GetProfileState>(
      listener: (context, state) {
        if (state is GetProfileLoadedState) {
          nameController.text = state.model.admin?.name ?? "";
          emailController.text = state.model.admin?.email ?? "";
          role = state.model.admin?.role;
          
        }
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heightBox20(),
                  heightBox20(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.whiteColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextWidget(
                          text: "Profile Image",
                        ),
                        heightBox10(),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              border: Border.all(
                                color: AppColors.greyColor,
                              ),
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.whiteColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextWidget(
                          text: "Username",
                        ),
                        heightBox5(),
                        TextFormFieldWidget(
                          controller: nameController,
                        ),
                        heightBox10(),
                        const TextWidget(
                          text: "Password",
                        ),
                        heightBox5(),
                        TextFormFieldWidget(
                          controller: passwordController,
                        ),
                        heightBox10(),
                        const TextWidget(
                          text: "Email",
                        ),
                        heightBox5(),
                        TextFormFieldWidget(
                          controller: emailController,
                        ),
                        heightBox20(),
                        BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
                          listener: (context, state) {
                            if (state is UpdateProfileErrorState) {
                             showMessage(context,  state.error);
                              return;
                            }

                            if (state is UpdateProfileLoadedState) {
                             showMessage(context,  "Update Sucessfully");
                              Navigator.pop(context);
                              context.read<GetProfileCubit>().getProfile(context);
                            }
                          },
                          builder: (context, state) {
                            return CustomOutlinedButton(
                              inProgress: (state is UpdateProfileLoadingState),
                              onPressed: () {
                                if (state is UpdateProfileLoadingState) return;
                                context.read<UpdateProfileCubit>().updateProfile(
                                      email: emailController.text,
                                      name: nameController.text,
                                      password: passwordController.text,
                                      profileImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                      userId: userId,
                                      selectedPermissions: role == "admin"
                                          ? {
                                              'Dashboard': true,
                                              'Movie': true,
                                              'Music': true,
                                              'Web Series': true,
                                              'Tv Show': true,
                                              'Live TV': true,
                                              'Short Film': true,
                                              'Ads': true,
                                              'Rentals': true,
                                              'Language': true,
                                              'Genre': true,
                                              'Users': true,
                                              'Sub Admin': true,
                                              'Subscription': true,
                                              'Reports': true,
                                              'Notification': true,
                                              'Settings': true
                                            }
                                          : null,
                                    );
                              },
                              buttonText: 'Save',
                              borderRadius: 15,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  heightBox30(),
                  backButton(context),
                  heightBox30(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
