import 'dart:developer';
import 'dart:io';
import 'package:elite_admin/bloc/trailer/get_all_trailer/get_all_trailer_cubit.dart';
import 'package:elite_admin/bloc/trailer/get_all_trailer/get_all_trailer_model.dart';
import 'package:elite_admin/bloc/trailer/post_trailer/post_trailer_cubit.dart';
import 'package:elite_admin/bloc/trailer/update_trailer/update_trailer_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/constant/image_picker_utils.dart';
import 'package:elite_admin/utils/toast.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_editor.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:html/parser.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class AddUpdateTrailerScreen extends StatefulWidget {
  const AddUpdateTrailerScreen({super.key, this.id, this.model});
  final String? id;
  final Trailor? model;

  @override
  State<AddUpdateTrailerScreen> createState() => _AddUpdateTrailerScreenState();
}

class _AddUpdateTrailerScreenState extends State<AddUpdateTrailerScreen> with Utility {
  int? progressPercent;
  final TextEditingController descriptionTextController = TextEditingController();
  final FocusNode descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      movieNameController.text = widget.model?.movieName ?? '';
      if (Platform.isWindows) {
        final rawHtml = widget.model?.description ?? "";
        final document = html_parser.parse(rawHtml);
        final cleanText = document.body?.text ?? "";
        descriptionTextController.text = cleanText.trim();
      }
      status = widget.model?.status ?? false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    movieNameController.dispose();
  }

  XFile? _selectedImage;
  XFile? _selectedPosterImage;
  final HtmlEditorController descriptionController = HtmlEditorController();
  TextEditingController movieNameController = TextEditingController();

  final FocusNode videoLinkFocusNode = FocusNode();
  final FocusNode trailerVideoLinkFocusNode = FocusNode();
  final FocusNode rentedTimeFocusNode = FocusNode();
  final FocusNode trailerLinkFocusNode = FocusNode();
  final FocusNode movieNameFocusNode = FocusNode();

  String? selectedAction = 'Play';
  String? selectedVideoType = 'video';
  XFile? _selectedVideo;
  String selectedQuality = 'Yes';
  bool isHighlighted = false;
  String seelctedSubtitle = 'Yes';
  bool isMovieOnRent = false;
  bool showSubscription = true;
  bool status = false;

  final List<String> yesNoList = ['Yes', 'No'];
  final List<String> videoUplaodType = ['link', 'video'];

  Future<String> getVideoDuration(String path) async {
    final controller = VideoPlayerController.file(File(path));
    await controller.initialize();
    await Future.delayed(const Duration(seconds: 1));

    final videoValue = controller.value;

    // Log all metadata values
    log("========== VIDEO METADATA ==========");
    log("isInitialized: ${videoValue.isInitialized}");
    log("duration: ${videoValue.duration}");
    log("size: ${videoValue.size}");
    log("aspectRatio: ${videoValue.aspectRatio}");
    log("isPlaying: ${videoValue.isPlaying}");
    log("volume: ${videoValue.volume}");
    log("position: ${videoValue.position}");
    log("buffered: ${videoValue.buffered}");
    log("playback speed: ${videoValue.playbackSpeed}");
    log("errorDescription: ${videoValue.errorDescription}");
    log("====================================");

    final duration = controller.value.duration;
    controller.dispose();

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    showMessage(context, " VideoDuration $hours:$minutes:$seconds - $duration");

    if (duration.inHours > 0) {
      return "$hours:$minutes:$seconds";
    } else {
      return "$minutes:$seconds";
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePickerUtil.pickImageFromGallery(
      context: context,
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
      initAspectRatio: CropAspectRatioPreset.square,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  Future<void> _pickPosterImage() async {
    final pickedFile = await ImagePickerUtil.pickImageFromGallery(
      context: context,
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
      initAspectRatio: CropAspectRatioPreset.ratio3x2,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedPosterImage = pickedFile;
      });
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile == null) {
      showMessage(context, "No video selected.");
      return;
    }

    if (!pickedFile.path.toLowerCase().endsWith('.mp4')) {
      showMessage(context, "File Not Supported. Please select an MP4 video.");
      return;
    }

    if (pickedFile.path.endsWith('.mp4')) {
      setState(() {
        _selectedVideo = pickedFile;
      });
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
                TextWidget(
                  text: widget.id != null ? "Update Trailer" : "Add Trailer",
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                heightBox10(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.whiteColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextWidget(text: "Cover Image"),
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
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.whiteColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextWidget(text: "Poster Image"),
                      heightBox10(),
                      GestureDetector(
                        onTap: _pickPosterImage,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(color: AppColors.greyColor),
                          ),
                          child: _selectedPosterImage == null
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
                                    File(_selectedPosterImage!.path),
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
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.whiteColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextWidget(text: "Movie Name"),
                      heightBox5(),
                      TextFormFieldWidget(controller: movieNameController, focusNode: movieNameFocusNode),

                      heightBox10(),
                      const TextWidget(text: "Video"),
                      heightBox5(),

                      _selectedVideo != null
                          ? Text("Selected video: ${_selectedVideo!.name}")
                          : const Text("No video selected."),
                      heightBox5(),
                      CustomOutlinedButton(onPressed: _pickVideo, buttonText: "Pick Video"),

                      heightBox10(),
                      const TextWidget(text: "Status"),
                      heightBox10(),
                      Switch(
                        activeColor: AppColors.zGreenColor,
                        value: status,
                        onChanged: (v) {
                          setState(() {
                            status = v;
                          });
                        },
                      ),
                      heightBox10(),

                      const TextWidget(text: "Description"),
                      heightBox5(),
                      InkWell(
                        onTap: () {
                          videoLinkFocusNode.unfocus();
                          movieNameFocusNode.unfocus();
                          rentedTimeFocusNode.unfocus();
                          Focus.of(context).unfocus();
                        },
                        child: SizedBox(
                          height: Platform.isWindows ? null : 500,
                          child: Platform.isWindows
                              ? TextField(
                                  controller: descriptionTextController,
                                  focusNode: descriptionFocusNode,
                                  maxLines: 12,
                                  decoration: InputDecoration(
                                    hintText: "Enter trailer description",
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    contentPadding: const EdgeInsets.all(12),
                                  ),
                                )
                              : CustomHtmlEditor(
                                  hint: "",
                                  onPressed: () async {
                                    final contentData = await descriptionController.getText();
                                    try {
                                      final document = parse(contentData);
                                      final validHtml = document.outerHtml;
                                      log("Validated HTML: $validHtml");
                                    } catch (e) {
                                      log("Invalid HTML structure: $e");
                                    }
                                  },
                                  controller: descriptionController,
                                  htmlContent: widget.model?.description ?? "",
                                ),
                        ),
                      ),
                      BlocConsumer<UpdateTrailerCubit, UpdateTrailerState>(
                        listener: (context, state) {
                          if (state is UpdateTrailerErrorState) {
                            showMessage(context, state.error);
                            return;
                          }

                          if (state is UpdateTrailerLoadedState) {
                            showMessage(context, "Update Sucessfully");
                            Navigator.pop(context);
                            context.read<GetAllTrailerCubit>().getAllTrailer();
                          }
                        },
                        builder: (context, updateState) {
                          if (updateState is UpdateTrailerProgressState) {
                            progressPercent = updateState.percent;
                          }
                          return BlocConsumer<PostTrailerCubit, PostTrailerState>(
                            listener: (context, state) {
                              if (state is PostTrailerErrorState) {
                                showMessage(context, state.error);
                                return;
                              }

                              if (state is PostTrailerLaodedState) {
                                showMessage(context, "Post Sucessfully");
                                Navigator.pop(context);
                                context.read<GetAllTrailerCubit>().getAllTrailer();
                              }
                            },
                            builder: (context, state) {
                              int? progressPercent;
                              final inProgress =
                                  state is PostTrailerLoadingState ||
                                  state is PostTrailerProgressState ||
                                  updateState is UpdateTrailerLoadingState ||
                                  updateState is UpdateTrailerProgressState;

                              if (state is PostTrailerProgressState) {
                                progressPercent = state.percent;
                              }

                              if (updateState is UpdateTrailerProgressState) {
                                progressPercent = updateState.percent;
                              }

                              return CustomOutlinedButton(
                                progress: progressPercent,
                                inProgress: inProgress,
                                onPressed: () async {
                                  var validHtml;
                                  try {
                                    final contentData = await descriptionController.getText();
                                    final document = parse(contentData);
                                    validHtml = document.outerHtml;
                                    log("Validated HTML: $validHtml");
                                  } catch (e) {}

                                  if (state is PostTrailerLoadingState || updateState is UpdateTrailerLoadingState) {
                                    return;
                                  }
                                  if (widget.id != null) {
                                    context.read<UpdateTrailerCubit>().updateMovies(
                                      id: widget.id ?? "",
                                      coverImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                      description: validHtml ?? "",
                                      movieName: movieNameController.text,
                                      trailerVideo: _selectedVideo != null ? File(_selectedVideo!.path) : null,
                                      posterImg: _selectedPosterImage != null ? File(_selectedPosterImage!.path) : null,
                                      status: status,
                                    );
                                    return;
                                  }

                                  if (movieNameController.text.isEmpty) {
                                    showMessage(context, "Movie Name is required");
                                    return;
                                  }

                                  // if (selectedGenre == null) {
                                  //  showMessage(context, "Genre is required");
                                  //   return;
                                  // }

                                  // if (await descriptionController.getText() == '') {
                                  //   showMessage(context, "Description is required");
                                  //   return;
                                  // }

                                  if (_selectedVideo == null) {
                                    showMessage(context, "Video file or video link is required");
                                    return;
                                  }

                                  context.read<PostTrailerCubit>().postMovies(
                                    coverImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                    description: validHtml ?? "",
                                    movieName: movieNameController.text,
                                    trailerVideo: _selectedVideo != null ? File(_selectedVideo!.path) : null,
                                    posterImg: _selectedPosterImage != null ? File(_selectedPosterImage!.path) : null,
                                    status: status,
                                  );
                                },
                                buttonText: widget.id != null ? "Save Trailer" : "Upload Trailer",
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                heightBox20(),
                backButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
