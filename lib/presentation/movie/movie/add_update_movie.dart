import 'dart:developer';
import 'dart:io';
import 'package:elite_admin/utils/toast.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elite_admin/bloc/movie/category/get_all_category/get_all_category_cubit.dart';
import 'package:elite_admin/bloc/movie/genre/get_all_genre/get_all_genre_cubit.dart';
import 'package:elite_admin/bloc/movie/language/get_all_language/get_all_language_cubit.dart';
import 'package:elite_admin/bloc/movie/upload_movie/get_all_movie/get_all_movie_cubit.dart';
import 'package:elite_admin/bloc/movie/upload_movie/get_all_movie/get_all_movie_model.dart';
import 'package:elite_admin/bloc/movie/upload_movie/post_movie/post_movie_cubit.dart';
import 'package:elite_admin/bloc/movie/upload_movie/update_movie/update_movie_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/constant/image_picker_utils.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_dropdown.dart';
import 'package:elite_admin/utils/widget/custom_editor.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';
import 'package:video_player/video_player.dart';

class AddUpdateMoveiScreen extends StatefulWidget {
  const AddUpdateMoveiScreen({super.key, this.id, this.model});
  final String? id;
  final Movie? model;

  @override
  State<AddUpdateMoveiScreen> createState() => _AddUpdateMoveiScreenState();
}

class _AddUpdateMoveiScreenState extends State<AddUpdateMoveiScreen> with Utility {
  int? progressPercent;

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      movieNameController.text = widget.model?.movieName ?? '';
      releasedByController.text = widget.model?.releasedBy ?? '';
      releasedDateController.text = widget.model?.releasedDate ?? '';
      movieTimeController.text = widget.model?.movieTime ?? '';
      moviePriceController.text = widget.model?.movieRentPrice ?? '';
      isHighlighted = widget.model?.isHighlighted ?? false;
      status = widget.model?.status ?? false;
      trailerLinkController.text = widget.model?.trailorVideoLink ?? "";
      videoLinkController.text = widget.model?.videoLink ?? "";
      isMovieOnRent = widget.model?.isMovieOnRent ?? false;
      selectedQuality = widget.model?.quality == true ? 'Yes' : 'No';
      seelctedSubtitle = widget.model?.subtitle == true ? 'Yes' : 'No';
      rentedTimeDaysController.text = widget.model?.rentedTimeDays.toString() ?? '';
      showSubscription = widget.model?.showSubscription ?? true;
      positionController.text = widget.model?.position != null ? widget.model!.position.toString() : "";
      log("positionController--> $positionController ${widget.model?.position.runtimeType}--");
    }
  }

  @override
  void dispose() {
    super.dispose();
    videoLinkController.dispose();
    trailerLinkController.dispose();
    movieNameController.dispose();
    releasedByController.dispose();
    releasedDateController.dispose();
    movieTimeController.dispose();
    moviePriceController.dispose();
  }

  XFile? _selectedImage;
  XFile? _selectedPosterImage;
  final HtmlEditorController descriptionController = HtmlEditorController();
  TextEditingController videoLinkController = TextEditingController();
  TextEditingController trailerVideoLink = TextEditingController();
  TextEditingController trailerLinkController = TextEditingController();
  TextEditingController movieNameController = TextEditingController();
  TextEditingController releasedByController = TextEditingController();
  TextEditingController releasedDateController = TextEditingController();
  TextEditingController movieTimeController = TextEditingController();
  TextEditingController moviePriceController = TextEditingController();
  TextEditingController rentedTimeDaysController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  final FocusNode videoLinkFocusNode = FocusNode();
  final FocusNode trailerVideoLinkFocusNode = FocusNode();
  final FocusNode rentedTimeFocusNode = FocusNode();
  final FocusNode trailerLinkFocusNode = FocusNode();
  final FocusNode movieNameFocusNode = FocusNode();
  final FocusNode releasedByFocusNode = FocusNode();
  final FocusNode releasedDateFocusNode = FocusNode();
  final FocusNode movieTimeFocusNode = FocusNode();
  final FocusNode moviePriceFocusNode = FocusNode();
  final FocusNode positionFocusNode = FocusNode();
  final FocusNode moveiPriceFocusNode = FocusNode();

  String? selectedLanguage;
  String? selectedLanguageId;

  String? selectedGenre;
  String? seletedGenreId;

  String? selectedCategory;
  String? selectedCategoryId;

  String? selectedAction = 'Play';
  String? selectedVideoType = 'video';
  XFile? _selectedVideo;
  XFile? _selectedTrailer;
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

  bool _loading = false;

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
        _loading = true;
      });
      try {
        final duration = await getVideoDuration(pickedFile.path);
        setState(() {
          movieTimeController.text = duration;
          _loading = false;
        });
      } catch (e) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _pickTralier() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null && pickedFile.path.endsWith('.mp4')) {
      setState(() {
        _selectedTrailer = pickedFile;
      });
    } else {}
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
                  text: widget.id != null ? "Update Movie" : "Add Movies",
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
                      const TextWidget(text: "Select Language"),
                      heightBox5(),
                      BlocBuilder<GetAllLanguageCubit, GetAllLanguageState>(
                        builder: (context, state) {
                          if (state is GetAllLanguageLoadedState) {
                            final languageNames =
                                state.model.data?.map((datum) => datum.name).whereType<String>().toList() ?? [];
                            return CustomDropdown(
                              items: languageNames,
                              selectedValue: selectedLanguage,
                              onChanged: (value) {
                                setState(() {
                                  selectedLanguage = value;
                                  final selectedDatum = state.model.data?.firstWhere((datum) => datum.name == value);
                                  print("Selected Datum ID: ${selectedDatum?.id}");
                                  selectedLanguageId = selectedDatum?.id;
                                });
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      heightBox10(),
                      const TextWidget(text: "Select Genre"),
                      heightBox5(),
                      BlocBuilder<GetAllGenreCubit, GetAllGenreState>(
                        builder: (context, state) {
                          if (state is GetAllGenreLaodedState) {
                            final genres =
                                state.model.data?.map((datum) => datum.name).whereType<String>().toList() ?? [];
                            return CustomDropdown(
                              items: genres,
                              selectedValue: selectedGenre,
                              onChanged: (value) {
                                setState(() {
                                  selectedGenre = value;
                                  final selectedDatum = state.model.data?.firstWhere((datum) => datum.name == value);
                                  print("Selected Datum ID: ${selectedDatum?.id}");
                                  seletedGenreId = selectedDatum?.id;
                                });
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      heightBox10(),
                      heightBox10(),
                      const TextWidget(text: "Select Movie Category"),
                      heightBox5(),
                      BlocBuilder<GetAllMovieCategoryCubit, GetAllCategoryState>(
                        builder: (context, state) {
                          if (state is GetAllCategoryLoadedState) {
                            final genres =
                                state.model.categories?.map((datum) => datum.name).whereType<String>().toList() ?? [];
                            return CustomDropdown(
                              items: genres,
                              selectedValue: selectedCategory,
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value;
                                  final selectedDatum = state.model.categories?.firstWhere(
                                    (datum) => datum.name == value,
                                  );
                                  selectedCategoryId = selectedDatum?.id;
                                  print("Selected Datum ID: ${selectedDatum?.id}");
                                });
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      heightBox10(),
                      const TextWidget(text: "Movie Name"),
                      heightBox5(),
                      TextFormFieldWidget(controller: movieNameController, focusNode: movieNameFocusNode),
                      heightBox10(),
                      const TextWidget(text: "Movie Upload Type"),
                      heightBox5(),
                      CustomDropdown(
                        items: videoUplaodType,
                        selectedValue: selectedVideoType,
                        onChanged: (value) {
                          setState(() {
                            selectedVideoType = value!;
                          });
                        },
                      ),
                      heightBox10(),
                      const TextWidget(text: "Video"),
                      heightBox5(),
                      if (selectedVideoType == 'link') ...[
                        TextFormFieldWidget(
                          hintText: "Enter video link",
                          controller: videoLinkController,
                          focusNode: videoLinkFocusNode,
                        ),
                      ] else if (_loading)
                        const CircularProgressIndicator()
                      else ...[
                        _selectedVideo != null
                            ? Text("Selected video: ${_selectedVideo!.name}")
                            : const Text("No video selected."),
                        heightBox5(),
                        CustomOutlinedButton(onPressed: _pickVideo, buttonText: "Pick Video"),
                      ],
                      heightBox10(),
                      const TextWidget(text: "Tralier Upload Type"),
                      heightBox5(),
                      CustomDropdown(
                        items: videoUplaodType,
                        selectedValue: selectedVideoType,
                        onChanged: (value) {
                          setState(() {
                            selectedVideoType = value!;
                          });
                        },
                      ),
                      heightBox10(),
                      const TextWidget(text: "Video"),
                      heightBox5(),
                      if (selectedVideoType == 'link') ...[
                        TextFormFieldWidget(
                          hintText: "Enter video link",
                          focusNode: trailerLinkFocusNode,
                          controller: trailerLinkController,
                        ),
                      ] else ...[
                        _selectedTrailer != null
                            ? Text("Selected video: ${_selectedTrailer!.name}")
                            : const Text("No video selected."),
                        heightBox5(),
                        CustomOutlinedButton(onPressed: _pickTralier, buttonText: "Pick Video"),
                      ],
                      heightBox10(),
                      const TextWidget(text: "Quality ON/OFF"),
                      heightBox5(),
                      CustomDropdown(
                        items: yesNoList,
                        selectedValue: selectedQuality,
                        onChanged: (value) {
                          setState(() {
                            selectedQuality = value!;
                          });
                        },
                      ),
                      heightBox10(),
                      const TextWidget(text: "Subtitle ON/OFF"),
                      heightBox5(),
                      CustomDropdown(
                        items: yesNoList,
                        selectedValue: seelctedSubtitle,
                        onChanged: (value) {
                          setState(() {
                            seelctedSubtitle = value!;
                          });
                        },
                      ),
                      heightBox10(),
                      const TextWidget(text: "Released By"),
                      heightBox5(),
                      TextFormFieldWidget(focusNode: releasedByFocusNode, controller: releasedByController),
                      heightBox10(),
                      const TextWidget(text: "Released Date"),
                      heightBox5(),
                      TextFormFieldWidget(
                        focusNode: releasedDateFocusNode,
                        controller: releasedDateController,
                        readOnly: true,
                        isSuffixIconShow: true,
                        suffixIcon: InkWell(
                          onTap: () {
                            selectDate(context, releasedDateController);
                          },
                          child: const Icon(Icons.calendar_month_outlined),
                        ),
                      ),
                      heightBox10(),
                      const TextWidget(text: "Highlighted"),
                      heightBox10(),
                      Switch(
                        activeColor: AppColors.zGreenColor,
                        value: isHighlighted,
                        onChanged: (v) {
                          setState(() {
                            isHighlighted = v;
                          });
                        },
                      ),
                      heightBox10(),
                      const TextWidget(text: "Is Movie On Rent"),
                      heightBox10(),
                      Switch(
                        activeColor: AppColors.zGreenColor,
                        value: isMovieOnRent,
                        onChanged: (v) {
                          setState(() {
                            isMovieOnRent = v;
                            showSubscription = false;
                          });
                        },
                      ),
                      heightBox10(),
                      if (isMovieOnRent)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextWidget(text: "Movie Price"),
                            heightBox10(),
                            TextFormFieldWidget(
                              focusNode: moveiPriceFocusNode,
                              controller: moviePriceController,
                              hintText: "movie price",
                            ),
                          ],
                        ),
                      heightBox10(),
                      if (isMovieOnRent)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextWidget(text: "Rent Time Days"),
                            heightBox10(),
                            TextFormFieldWidget(
                              focusNode: rentedTimeFocusNode,
                              inputFormater: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              keyboardType: TextInputType.number,
                              controller: rentedTimeDaysController,
                              hintText: "Rent Time Days",
                            ),
                          ],
                        ),
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
                      const TextWidget(text: "Show Subscription"),
                      heightBox10(),
                      Switch(
                        activeColor: AppColors.zGreenColor,
                        value: showSubscription,
                        onChanged: (v) {
                          showSubscription = v;
                          setState(() {});
                        },
                      ),
                      heightBox10(),
                      const TextWidget(text: "Position"),
                      heightBox5(),
                      TextFormFieldWidget(
                        controller: positionController,
                        focusNode: positionFocusNode,
                        keyboardType: TextInputType.number,
                        inputFormater: [LengthLimitingTextInputFormatter(4)],
                      ),
                      heightBox10(),
                      const TextWidget(text: "Description"),
                      heightBox5(),
                      InkWell(
                        onTap: () {
                          videoLinkFocusNode.unfocus();
                          movieNameFocusNode.unfocus();
                          releasedByFocusNode.unfocus();
                          releasedDateFocusNode.unfocus();
                          positionFocusNode.unfocus();
                          rentedTimeFocusNode.unfocus();
                          moveiPriceFocusNode.unfocus();
                          Focus.of(context).unfocus();
                        },
                        child: SizedBox(
                          height: 500,
                          child: CustomHtmlEditor(
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
                      BlocConsumer<UpdateMovieCubit, UpdateMovieState>(
                        listener: (context, state) {
                          if (state is UpdateMovieErrorState) {
                            showMessage(context, state.error);
                            return;
                          }

                          if (state is UpdateMovieLoadedState) {
                            showMessage(context, "Update Sucessfully");
                            Navigator.pop(context);
                            context.read<GetAllMovieCubit>().getAllMovie();
                          }
                        },
                        builder: (context, updateState) {
                          if (updateState is UpdateMovieProgressState) {
                            progressPercent = updateState.percent;
                          }
                          return BlocConsumer<PostMovieCubit, PostMovieState>(
                            listener: (context, state) {
                              if (state is PostMovieErrorState) {
                                showMessage(context, state.error);
                                return;
                              }

                              if (state is PostMovieLoadedState) {
                                showMessage(context, "Post Sucessfully");
                                Navigator.pop(context);
                                context.read<GetAllMovieCubit>().getAllMovie();
                              }
                            },
                            builder: (context, state) {
                              int? progressPercent;
                              final inProgress =
                                  state is PostMovieLoadingState ||
                                  state is PostMovieProgressState ||
                                  updateState is UpdateMovieLoadingState ||
                                  updateState is UpdateMovieProgressState;

                              if (state is PostMovieProgressState) {
                                progressPercent = state.percent;
                              }

                              if (updateState is UpdateMovieProgressState) {
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
                                  } catch (e) {
                                    
                                  }
                                  if (state is PostMovieLoadingState || updateState is UpdateMovieLoadingState) {
                                    return;
                                  }
                                  if (widget.id != null) {
                                    context.read<UpdateMovieCubit>().updateMovies(
                                      showSubscription: showSubscription,
                                      id: widget.id ?? "",
                                      coverImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                      description: validHtml ?? "",
                                      isMovieOnRent: isMovieOnRent,
                                      isHighlighted: isHighlighted,
                                      movieCategoryId: selectedCategoryId,
                                      movieLanguage: selectedLanguageId,
                                      genreId: seletedGenreId,
                                      movieName: movieNameController.text,
                                      subtitle: seelctedSubtitle == 'Yes' ? true : false,
                                      movieRentPrice: moviePriceController.text,
                                      movieTime: movieTimeController.text,
                                      movieVideo: _selectedVideo != null ? File(_selectedVideo!.path) : null,
                                      posterImg: _selectedPosterImage != null ? File(_selectedPosterImage!.path) : null,
                                      quality: selectedQuality == 'Yes' ? true : false,
                                      releasedBy: releasedByController.text,
                                      releasedDate: releasedDateController.text,
                                      status: status,
                                      trailorVideo: _selectedTrailer != null ? File(_selectedTrailer!.path) : null,
                                      trailor_video_link: trailerLinkController.text,
                                      video_link: videoLinkController.text,
                                      rented_time_days: rentedTimeDaysController.text.isEmpty
                                          ? null
                                          : int.tryParse(rentedTimeDaysController.text),
                                      position: positionController.text.isNotEmpty ? positionController.text : null,
                                    );
                                    return;
                                  }

                                  if (selectedCategory == null) {
                                    showMessage(context, "Select Movie Category");
                                    return;
                                  }

                                  // if (selectedGenre == null) {
                                  //  showMessage(context, "Select Movie Genre");
                                  //   return;
                                  // }

                                  if (selectedLanguage == null) {
                                    showMessage(context, "Select Movie Langiage");
                                    return;
                                  }

                                  if (movieNameController.text.isEmpty) {
                                    showMessage(context, "Movie Name is required");
                                    return;
                                  }
                                  if (selectedLanguage == null) {
                                    showMessage(context, "Movie Language is required");
                                    return;
                                  }
                                  // if (selectedGenre == null) {
                                  //  showMessage(context, "Genre is required");
                                  //   return;
                                  // }

                                  if (releasedByController.text.isEmpty) {
                                    showMessage(context, "Released By is required");
                                    return;
                                  }
                                  if (releasedDateController.text.isEmpty) {
                                    showMessage(context, "Released Date is required");
                                    return;
                                  }
                                  // if (await descriptionController.getText() == '') {
                                  //   showMessage(context, "Description is required");
                                  //   return;
                                  // }

                                  if (_selectedVideo == null && videoLinkController.text.isEmpty) {
                                    showMessage(context, "Video file or video link is required");
                                    return;
                                  }

                                  context.read<PostMovieCubit>().postMovies(
                                    showSubscription: showSubscription,
                                    coverImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                    description: validHtml,
                                    isHighlighted: isHighlighted,
                                    movieCategoryId: selectedCategoryId,
                                    movieLanguage: selectedLanguageId,
                                    genreId: seletedGenreId,
                                    movieName: movieNameController.text,
                                    subtitle: seelctedSubtitle == 'Yes' ? true : false,
                                    movieRentPrice: moviePriceController.text,
                                    movieTime: movieTimeController.text,
                                    movieVideo: _selectedVideo != null ? File(_selectedVideo!.path) : null,
                                    trailorVideo: _selectedTrailer != null ? File(_selectedTrailer!.path) : null,
                                    posterImg: _selectedPosterImage != null ? File(_selectedPosterImage!.path) : null,
                                    quality: selectedQuality == 'Yes' ? true : false,
                                    releasedBy: releasedByController.text,
                                    releasedDate: releasedDateController.text,
                                    status: status,
                                    isMovieOnRent: isMovieOnRent,
                                    trailor_video_link: trailerLinkController.text,
                                    video_link: videoLinkController.text,
                                    rented_time_days: rentedTimeDaysController.text.isEmpty
                                        ? null
                                        : int.tryParse(rentedTimeDaysController.text),
                                    position: (positionController.text.isNotEmpty) ? positionController.text : null,
                                  );
                                },
                                buttonText: widget.id != null ? "Save Movie" : "Upload Movie",
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
