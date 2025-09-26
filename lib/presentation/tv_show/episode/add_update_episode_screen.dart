import 'dart:developer';
import 'dart:io';
import 'package:elite_admin/utils/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elite_admin/bloc/tv_show/episode_tv_show/get_all_episode/get_all_episode_cubit.dart';
import 'package:elite_admin/bloc/tv_show/episode_tv_show/get_all_episode/get_all_episode_model.dart';
import 'package:elite_admin/bloc/tv_show/episode_tv_show/post_episode/post_episode_cubit.dart';
import 'package:elite_admin/bloc/tv_show/episode_tv_show/update_episode/update_episode_cubit.dart';
import 'package:elite_admin/bloc/tv_show/season_tv_show/get_all_season/get_all_season_cubit.dart';
import 'package:elite_admin/bloc/tv_show/tv_show/get_all_tv_show/get_all_tv_show_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/constant/image_picker_utils.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_dropdown.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';
import 'package:video_player/video_player.dart';

class AddUpdateTvShowEpisodeScreen extends StatefulWidget {
  const AddUpdateTvShowEpisodeScreen({super.key, this.id, this.item});
  final String? id;
  final Datum? item;

  @override
  State<AddUpdateTvShowEpisodeScreen> createState() => _AddUpdateTvShowEpisodeScreenState();
}

class _AddUpdateTvShowEpisodeScreenState extends State<AddUpdateTvShowEpisodeScreen> with Utility {
  TextEditingController episodeController = TextEditingController();
  TextEditingController videoLinkController = TextEditingController();
  TextEditingController episodeNoController = TextEditingController();
  final TextEditingController _releasedDateController = TextEditingController();
  TextEditingController movieTimeController = TextEditingController();
  XFile? _selectedImage;
  XFile? _selectedVideo;

  String? selectedSeason;
  String? selectedSeasonId;

  String? selectedSeries;
  String? selectedSeriesId;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePickerUtil.pickImageFromGallery(
            context: context,
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
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

  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null && pickedFile.path.endsWith('.mp4')) {
      setState(() {
        _selectedVideo = pickedFile;
      });
      movieTimeController.text = await getVideoDuration(pickedFile.path);
      print("Video Duration:===== ${movieTimeController.text}");
    } else {}
  }

  @override
  void dispose() {
    episodeController.dispose();
    episodeNoController.dispose();
    _releasedDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.id != null) {
      episodeController.text = widget.item?.episodeName ?? "";
      episodeNoController.text = widget.item?.episodeNo ?? "";
      _releasedDateController.text = widget.item?.releasedDate ?? "";
      movieTimeController.text = widget.item?.movieTime ?? "";
    }
    super.initState();
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
                TextWidget(
                  text: widget.id != null ? "Update Episode" : "Add Episode",
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
                        text: "Cover Image",
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
                                    SvgPicture.asset(AppImages.imageSvg),
                                    heightBox10(),
                                    const TextWidget(text: "Select a File"),
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
                        text: "Select Series",
                      ),
                      heightBox5(),
                      BlocBuilder<GetAllTvShowSeriesCubit, GetAllSeriesState>(
                        builder: (context, state) {
                          if (state is GetAllSeriesLoadedState) {
                            final genres =
                                state.model.data?.map((datum) => datum.seriesName).whereType<String>().toList() ?? [];
                            return CustomDropdown(
                              items: genres,
                              selectedValue: selectedSeries,
                              onChanged: (value) {
                                setState(() {
                                  selectedSeries = value;
                                  log("selectedSeries $selectedSeries $value");
                                  final selectedDatum =
                                      state.model.data?.firstWhere((datum) => datum.seriesName == value);
                                  if (kDebugMode) {
                                    print("Selected Datum ID: ${selectedDatum?.id}");
                                  }
                                  selectedSeriesId = selectedDatum?.id;
                                });
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      heightBox10(),
                      const TextWidget(
                        text: "Select  Season",
                      ),
                      heightBox5(),
                      BlocBuilder<GetAllTvShowSeasonCubit, GetAllSeasonState>(
                        builder: (context, state) {
                          if (state is GetAllSeasonLoadedState) {
                            final genres = state.model.data
                                    ?.map((datum) => '${datum.series?.seriesName} - ${datum.seasonName}')
                                    .whereType<String>()
                                    .toList() ??
                                [];
                            return CustomDropdown(
                                items: genres,
                                selectedValue: selectedSeason,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSeason = value;
                                    log("selectedSeason $selectedSeason");
                                    final parts = value?.split(' - ');
                                    final seriesName = parts?.first;
                                    log("seriesName ${parts?.first} seasonName ${parts?.last}");
                                    final selectedDatum =
                                        state.model.data?.firstWhere((datum) => datum.series?.seriesName == seriesName);
                                    log("Selected Datum ID: $selectedDatum");

                                    selectedSeasonId = selectedDatum?.id;
                                  });
                                });
                          }
                          return const SizedBox();
                        },
                      ),
                      heightBox10(),
                      const TextWidget(
                        text: "Episode Title",
                      ),
                      heightBox5(),
                      TextFormFieldWidget(
                        controller: episodeController,
                      ),
                      heightBox10(),
                      const TextWidget(
                        text: "Episode Number",
                      ),
                      heightBox5(),
                      TextFormFieldWidget(
                        controller: episodeNoController,
                      ),
                      heightBox10(),
                      const TextWidget(
                        text: "Released Date",
                      ),
                      heightBox5(),
                      TextFormFieldWidget(
                        controller: _releasedDateController,
                        readOnly: true,
                        isSuffixIconShow: true,
                        suffixIcon: InkWell(
                            onTap: () {
                              selectDate(context, _releasedDateController);
                            },
                            child: const Icon(Icons.calendar_month_outlined)),
                      ),
                      heightBox10(),
                      const TextWidget(text: "Video"),
                      heightBox5(),
                      _selectedVideo != null
                          ? Text("Selected video: ${_selectedVideo!.name}")
                          : const Text("No video selected."),
                      heightBox5(),
                      CustomOutlinedButton(
                        onPressed: _pickVideo,
                        buttonText: "Pick Video",
                      ),
                      heightBox10(),
                      const Center(child: TextWidget(text: "Or")),
                      heightBox15(),
                      const TextWidget(text: "Video Link"),
                      heightBox10(),
                      TextFormFieldWidget(
                        controller: videoLinkController,
                      ),
                      heightBox10(),
                      BlocConsumer<UpdateTvShowEpisodeCubit, UpdateEpisodeState>(
                        listener: (context, state) {
                          if (state is UpdateEpisodeErrorState) {
                           showMessage(context,  state.error);
                            return;
                          }
                          if (state is UpdateEpisodeLoadedState) {
                            Navigator.pop(context);
                           showMessage(context,  "Update Successfully ✅");
                          }
                        },
                        builder: (context, updateState) {
                          return BlocConsumer<PostTvShowEpisodeCubit, PostEpisodeState>(
                            listener: (context, state) {
                              if (state is PostEpisodeErrorState) {
                               showMessage(context,  "${state.error} ❌");
                                return;
                              }

                              if (state is PostEpisodeLoadedState) {
                                Navigator.pop(context);
                               showMessage(context,  "Post Successfully ✅");
                                context.read<GetAllTvShowEpisodeCubit>().getAllEpisode();
                              }
                            },
                            builder: (context, postState) {
                              return CustomOutlinedButton(
                                inProgress:
                                    (postState is PostEpisodeLoadingState || updateState is UpdateEpisodeLoadingState),
                                onPressed: () {
                                  if (widget.id != null) {
                                    context.read<UpdateTvShowEpisodeCubit>().updateEpisode(
                                          id: widget.id ?? "",
                                          coverImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                          episodeName: episodeController.text,
                                          episodeNo: episodeNoController.text,
                                          releasedDate: _releasedDateController.text,
                                          seasonId: selectedSeasonId,
                                          seriesId: selectedSeriesId,
                                          video: _selectedVideo != null ? File(_selectedVideo!.path) : null,
                                          movieTime: movieTimeController.text.isEmpty ? null : movieTimeController.text,
                                          status: true,
                                          videoLink: videoLinkController.text.isEmpty ? null : videoLinkController.text,
                                        );
                                    return;
                                  }

                                  if (_selectedImage == null) {
                                   showMessage(context,  "Upload Cover Image");
                                    return;
                                  }
                                  if (episodeController.text.isEmpty) {
                                   showMessage(context,  "Please Enter Episode name");
                                    return;
                                  }
                                  if (episodeNoController.text.isEmpty) {
                                   showMessage(context,  "Please Enter Episode No");
                                    return;
                                  }

                                  if (_releasedDateController.text.isEmpty) {
                                   showMessage(context,  "Please Enter Episode No");
                                    return;
                                  }

                                  if (selectedSeasonId == null) {
                                   showMessage(context,  "Select season id");
                                    return;
                                  }

                                  if (selectedSeriesId == null) {
                                   showMessage(context,  "Select series id");
                                    return;
                                  }

                                  if (_selectedVideo == null && videoLinkController.text.isEmpty) {
                                   showMessage(context,  "Select either a video file or provide a video link");
                                    return;
                                  }

                                  context.read<PostTvShowEpisodeCubit>().postEpisode(
                                        coverImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                        episodeName: episodeController.text,
                                        episodeNo: episodeNoController.text,
                                        releasedDate: _releasedDateController.text,
                                        seasonId: selectedSeasonId,
                                        seriesId: selectedSeriesId,
                                        video: _selectedVideo != null ? File(_selectedVideo!.path) : null,
                                        movieTime: movieTimeController.text.isEmpty ? null : movieTimeController.text,
                                        videoLink: videoLinkController.text.isEmpty ? null : videoLinkController.text,
                                      );
                                },
                                buttonText: widget.id != null ? "Save Episode" : "Upload Episode",
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                heightBox30(),
                backButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
