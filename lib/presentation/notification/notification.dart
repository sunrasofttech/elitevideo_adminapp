import 'package:elite_admin/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite_admin/bloc/notification/send_notification/send_notification_cubit.dart';
import 'package:elite_admin/bloc/setting/get_setting/get_setting_cubit.dart';
import 'package:elite_admin/bloc/setting/update_setting/update_setting_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    context.read<GetSettingCubit>().getSetting();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.lightGreyColor,
        title: const TextWidget(
          text: "Notification",
          fontWeight: FontWeight.w500,
          fontSize: 17,
        ),
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          indicatorColor: AppColors.blueColor,
          unselectedLabelColor: AppColors.greyColor,
          labelColor: AppColors.blueColor,
          tabs: const [
            Tab(text: "Notification Settings"),
            Tab(text: "Send Notification"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          SettingUi(),
          SendNotificationUi(),
        ],
      ),
    );
  }
}

class SettingUi extends StatefulWidget {
  const SettingUi({super.key});

  @override
  State<SettingUi> createState() => _SettingUiState();
}

class _SettingUiState extends State<SettingUi> with Utility {
  final projectIdController = TextEditingController();
  final privateKeyController = TextEditingController();
  final clentEmailController = TextEditingController();
  String? id;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocListener<GetSettingCubit, GetSettingState>(
        listener: (context, state) {
          if (state is GetSettingLoadedState) {
            id = state.model.setting?.id ?? "";
            privateKeyController.text = state.model.setting?.firebasePrivateKey ?? "";
            projectIdController.text = state.model.setting?.firebaseProjectId ?? "";
            clentEmailController.text = state.model.setting?.firebaseClientEmail ?? "";
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heightBox10(),
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextWidget(
                        fontWeight: FontWeight.w600,
                        text: "Firebase Project Id",
                      ),
                      heightBox5(),
                      TextFormFieldWidget(
                        controller: projectIdController,
                      ),
                      heightBox10(),
                      const TextWidget(
                        fontWeight: FontWeight.w600,
                        text: "Firebase Client Email",
                      ),
                      heightBox5(),
                      TextFormFieldWidget(
                        controller: clentEmailController,
                      ),
                      heightBox10(),
                      const TextWidget(
                        fontWeight: FontWeight.w600,
                        text: "Firebase Private Key",
                      ),
                      heightBox5(),
                      TextFormFieldWidget(
                        controller: privateKeyController,
                      ),
                      heightBox10(),
                      BlocConsumer<UpdateSettingCubit, UpdateSettingState>(
                        listener: (context, state) {
                          if (state is UpdateSettingErrorState) {
                           showMessage(context,  state.error);
                          }
                          if (state is UpdateSettingLoadedState) {
                           showMessage(context,  "Update Succesfully");
                            context.read<GetSettingCubit>().getSetting();
                          }
                        },
                        builder: (context, state) {
                          return CustomOutlinedButton(
                            inProgress: (state is UpdateSettingLoadingState),
                            onPressed: () {
                              context.read<UpdateSettingCubit>().updateSetting(
                                    id: id,
                                    firebasePrivateKey: privateKeyController.text,
                                    firebaseClientEmail: clentEmailController.text,
                                    firebaseProjectId: projectIdController.text,
                                  );
                            },
                            buttonText: 'Save',
                          );
                        },
                      ),
                      heightBox50(),
                    ],
                  ),
                ),
              ),
              heightBox50(),
              heightBox50(),
              // InkWell(
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       const Icon(
              //         Icons.arrow_back,
              //         color: AppColors.blueColor,
              //       ),
              //       widthBox10(),
              //       const TextWidget(
              //         text: "Back",
              //         color: AppColors.blueColor,
              //         fontSize: 18,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class SendNotificationUi extends StatefulWidget {
  const SendNotificationUi({super.key});

  @override
  State<SendNotificationUi> createState() => _SendNotificationUiState();
}

class _SendNotificationUiState extends State<SendNotificationUi> with Utility {
  final titleController = TextEditingController();
  final mesageController = TextEditingController();
  // XFile? _selectedImage;

  // Future<void> _pickImage() async {
  //   final pickedFile = await ImagePickerUtil.pickImageFromGallery();
  //   if (pickedFile != null) {
  //     setState(() {
  //       _selectedImage = pickedFile;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   padding: const EdgeInsets.all(8),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(12),
            //     color: AppColors.whiteColor,
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const TextWidget(
            //         text: "Image (optional)",
            //       ),
            //       heightBox10(),
            //       // GestureDetector(
            //       //   onTap: _pickImage,
            //       //   child: Container(
            //       //     width: MediaQuery.of(context).size.width,
            //       //     padding: const EdgeInsets.all(8),
            //       //     decoration: BoxDecoration(
            //       //       borderRadius: const BorderRadius.all(
            //       //         Radius.circular(8),
            //       //       ),
            //       //       border: Border.all(
            //       //         color: AppColors.greyColor,
            //       //       ),
            //       //     ),
            //       //     child: _selectedImage == null
            //       //         ? Column(
            //       //             children: [
            //       //               SvgPicture.asset("asset/svg/profile-circle.svg"),
            //       //               heightBox10(),
            //       //               const TextWidget(text: "Select a profile picture"),
            //       //               const TextWidget(text: "Browse or Drag image here.."),
            //       //             ],
            //       //           )
            //       //         : ClipRRect(
            //       //             borderRadius: BorderRadius.circular(8),
            //       //             child: Image.file(
            //       //               File(_selectedImage!.path),
            //       //               width: double.infinity,
            //       //               height: 190,
            //       //               fit: BoxFit.cover,
            //       //             ),
            //       //           ),
            //       //   ),
            //       // ),
            //     ],
            //   ),
            // ),
            heightBox15(),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                color: AppColors.whiteColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextWidget(
                    text: "Notification title",
                  ),
                  heightBox5(),
                  TextFormFieldWidget(
                    controller: titleController,
                  ),
                  heightBox10(),
                  const TextWidget(
                    text: "Message",
                  ),
                  heightBox5(),
                  TextFormFieldWidget(
                    maxLine: 4,
                    controller: mesageController,
                  ),
                  heightBox15(),
                  BlocConsumer<SendNotificationCubit, SendNotificationState>(
                    listener: (context, state) {
                      if (state is SendNotificationErrorState) {
                       showMessage(context,  state.error);
                        return;
                      }
        
                      if (state is SendNotificationLoadedState) {
                        titleController.clear();
                        mesageController.clear();
                       showMessage(context,  "Message Send Sucessfully ...");
                      }
                    },
                    builder: (context, state) {
                      return CustomOutlinedButton(
                        onPressed: () {
                          context.read<SendNotificationCubit>().sendNotification(
                                titleController.text,
                                mesageController.text,
                              );
                        },
                        buttonText: 'Send Notification',
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
