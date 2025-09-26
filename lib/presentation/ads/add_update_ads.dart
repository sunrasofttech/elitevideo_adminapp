import 'dart:io';

import 'package:elite_admin/utils/toast.dart' show showMessage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elite_admin/bloc/ads/create_ads/create_ads_cubit.dart';
import 'package:elite_admin/bloc/ads/get_all_ads/get_all_ads_cubit.dart';
import 'package:elite_admin/bloc/ads/get_all_ads/get_all_ads_model.dart';
import 'package:elite_admin/bloc/ads/update_ads/update_ads_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/utils/formater.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';
import 'package:video_player/video_player.dart';

class AdsAddUpdateScreen extends StatefulWidget {
  const AdsAddUpdateScreen({super.key, this.id, this.data});
  final String? id;
  final Datum? data;

  @override
  State<AdsAddUpdateScreen> createState() => _AdsAddUpdateScreenState();
}

class _AdsAddUpdateScreenState extends State<AdsAddUpdateScreen> with Utility {
  XFile? _selectedVideo;

  final adsUrlController = TextEditingController();
  final videoTimeController = TextEditingController();
  final skipTimeController = TextEditingController();

  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedVideo = pickedFile;
      });
      videoTimeController.text = await getVideoDuration(pickedFile.path);
    }
  }

  @override
  void dispose() {
    adsUrlController.dispose();
    skipTimeController.dispose();
    videoTimeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.data != null) {
      adsUrlController.text = widget.data?.title ?? "";
      skipTimeController.text = widget.data?.skipTime ?? "";
      videoTimeController.text = widget.data?.videoTime ?? "";
    }
    super.initState();
  }

  Future<String> getVideoDuration(String path) async {
    final VideoPlayerController controller = VideoPlayerController.file(File(path));
    await controller.initialize();
    final Duration duration = controller.value.duration;
    controller.dispose();

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return "$hours:$minutes:$seconds";
    } else {
      return "$minutes:$seconds";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightBox15(),
                heightBox15(),
                TextWidget(
                  text: widget.id != null ? "Update Ads" : "Add Ads",
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                heightBox10(),
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
                        text: "Pick Video",
                      ),
                      heightBox10(),
                      GestureDetector(
                        onTap: _pickVideo,
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
                            child: _selectedVideo == null
                                ? Column(
                                    children: [
                                      SvgPicture.asset(AppImages.imageSvg),
                                      heightBox10(),
                                      const TextWidget(text: "Select a Video File"),
                                      const TextWidget(text: "Browse or Drag image here.."),
                                    ],
                                  )
                                : TextWidget(
                                    text: "${_selectedVideo!.path} Seleted.",
                                  )),
                      ),
                    ],
                  ),
                ),
                heightBox10(),
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
                      heightBox10(),
                      const TextWidget(
                        text: "title",
                      ),
                      heightBox5(),
                      TextFormFieldWidget(
                        controller: adsUrlController,
                      ),
                      heightBox10(),
                      heightBox10(),
                      const TextWidget(
                        text: "skip Time",
                      ),
                      heightBox5(),
                      TextFormFieldWidget(
                        controller: skipTimeController,
                        inputFormater: [TimeTextInputFormatter()],
                      ),
                      heightBox10(),
                      heightBox10(),
                      BlocConsumer<UpdateAdsCubit, UpdateAdsState>(
                        listener: (context, state) {
                          if (state is UpdateAdsErrorState) {
                           showMessage(context,  state.error);
                            return;
                          }

                          if (state is UpdateAdsLoadedState) {
                           showMessage(context,  "Update Sucessfully");
                            Navigator.pop(context);
                            context.read<GetAllAdsCubit>().getAllAds();
                          }
                        },
                        builder: (context, updateState) {
                          return BlocConsumer<CreateAdsCubit, CreateAdsState>(
                            listener: (context, state) {
                              if (state is CreateAdsErrorState) {
                               showMessage(context,  state.error);
                                return;
                              }

                              if (state is CreateAdsLaodedState) {
                               showMessage(context,  "Post Successfully");
                                Navigator.pop(context);
                                context.read<GetAllAdsCubit>().getAllAds();
                              }
                            },
                            builder: (context, state) {
                              return CustomOutlinedButton(
                                inProgress: (updateState is UpdateAdsLoadingState || state is CreateAdsLoadingState),
                                onPressed: () {
                                  if (widget.id != null) {
                                    context.read<UpdateAdsCubit>().updateAds(
                                          id: widget.id ?? "",
                                          adUrl: adsUrlController.text,
                                          adVideo: _selectedVideo != null ? File(_selectedVideo!.path) : null,
                                          skipTime: skipTimeController.text,
                                          videoTime: videoTimeController.text,
                                        );
                                    return;
                                  }
                                  context.read<CreateAdsCubit>().createAds(
                                        adUrl: adsUrlController.text,
                                        adVideo: _selectedVideo != null ? File(_selectedVideo!.path) : null,
                                        skipTime: skipTimeController.text,
                                        videoTime: videoTimeController.text,
                                      );
                                },
                                buttonText: widget.id != null ? "Save Ads" : "Add Ads",
                              );
                            },
                          );
                        },
                      ),
                      heightBox15(),
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
    );
  }
}
