import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elite_admin/bloc/movie/category/get_all_category/get_all_category_cubit.dart';
import 'package:elite_admin/bloc/movie/genre/get_all_genre/get_all_genre_cubit.dart';
import 'package:elite_admin/bloc/movie/language/get_all_language/get_all_language_cubit.dart';
import 'package:elite_admin/bloc/short_film/get_all_short_flim/get_all_short_film_cubit.dart';
import 'package:elite_admin/bloc/short_film/get_all_short_flim/get_all_short_film_model.dart';
import 'package:elite_admin/bloc/short_film/post_film/post_film_cubit.dart';
import 'package:elite_admin/bloc/short_film/update/update_film_cubit.dart';
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

class AddUpdateShortFlimScreen extends StatefulWidget {
  const AddUpdateShortFlimScreen({super.key, this.id, this.model});
  final String? id;
  final Datum? model;

  @override
  State<AddUpdateShortFlimScreen> createState() => _AddUpdateShortFlimScreenState();
}

class _AddUpdateShortFlimScreenState extends State<AddUpdateShortFlimScreen> with Utility {
  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      movieNameController.text = widget.model?.shortFilmTitle ?? '';
      releasedByController.text = widget.model?.releasedBy ?? '';
      releasedDateController.text = widget.model?.releasedDate ?? '';
      movieTimeController.text = widget.model?.movieTime ?? '';
      moviePriceController.text = widget.model?.movieRentPrice ?? '';
      isHighlighted = widget.model?.isHighlighted ?? false;
      status = widget.model?.status ?? false;
      videoLinkController.text = widget.model?.videoLink ?? "";
      isMovieOnRent = widget.model?.isMovieOnRent ?? false;
      selectedQuality = widget.model?.quality == true ? 'Yes' : 'No';
      seelctedSubtitle = widget.model?.subtitle == true ? 'Yes' : 'No';
      rentedTimeDaysController.text = widget.model?.rentedTimeDays.toString() ?? '';
      showSubscription = widget.model?.showSubscription ?? true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    videoLinkController.dispose();
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
  TextEditingController movieNameController = TextEditingController();
  TextEditingController releasedByController = TextEditingController();
  TextEditingController releasedDateController = TextEditingController();
  TextEditingController movieTimeController = TextEditingController();
  TextEditingController moviePriceController = TextEditingController();
  TextEditingController rentedTimeDaysController = TextEditingController();

  FocusNode videoLinkFocus = FocusNode();
  FocusNode movieNameFocus = FocusNode();
  FocusNode releasedByFocus = FocusNode();
  FocusNode releasedDateFocus = FocusNode();
  FocusNode movieTimeFocus = FocusNode();
  FocusNode moviePriceFocus = FocusNode();
  FocusNode rentedTimeDaysFocus = FocusNode();

  String? selectedLanguage;
  String? selectedLanguageId;

  String? selectedGenre;
  String? seletedGenreId;

  String? selectedCategory;
  String? selectedCategoryId;

  String? selectedAction = 'Play';
  String? selectedVideoType = 'video';
  XFile? _selectedVideo;
  // XFile? _selectedTrailer;
  String selectedQuality = 'Yes';
  bool isHighlighted = false;
  String seelctedSubtitle = 'Yes';
  bool isMovieOnRent = false;
  bool status = false;
  bool showSubscription = true;
  final List<String> yesNoList = ['Yes', 'No'];
  final List<String> videoUplaodType = ['link', 'video'];

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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePickerUtil.pickImageFromGallery(
      aspectRatio: const CropAspectRatio(ratioX: 5, ratioY: 3),
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
      aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
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
    if (pickedFile != null && pickedFile.path.endsWith('.mp4')) {
      setState(() {
        _selectedVideo = pickedFile;
      });
      movieTimeController.text = await getVideoDuration(pickedFile.path);
      print("Video Duration: ${movieTimeController.text}");
    } else {}
  }

  // Future<void> _pickTralier() async {
  //   final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
  //   if (pickedFile != null && pickedFile.path.endsWith('.mp4')) {
  //     setState(() {
  //       _selectedTrailer = pickedFile;
  //     });
  //   } else {}
  // }

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
                  text: widget.id != null ? "Update Short Film" : "Add Short Film",
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
                        text: "Poster Image",
                      ),
                      heightBox10(),
                      GestureDetector(
                        onTap: _pickPosterImage,
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.whiteColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextWidget(
                        text: "Select Language",
                      ),
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
                      const TextWidget(
                        text: "Select Genre",
                      ),
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
                      const TextWidget(
                        text: "Select Short Film Category",
                      ),
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
                                  final selectedDatum =
                                      state.model.categories?.firstWhere((datum) => datum.name == value);
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
                      const TextWidget(
                        text: "Short Film Name",
                      ),
                      heightBox5(),
                      TextFormFieldWidget(
                        focusNode: movieNameFocus,
                        controller: movieNameController,
                      ),
                      heightBox10(),
                      const TextWidget(
                        text: "Short Film Upload Type",
                      ),
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
                        ),
                      ] else ...[
                        _selectedVideo != null
                            ? Text("Selected video: ${_selectedVideo!.name}")
                            : const Text("No video selected."),
                        heightBox5(),
                        CustomOutlinedButton(
                          onPressed: _pickVideo,
                          buttonText: "Pick Video",
                        ),
                      ],
                      heightBox10(),
                      const TextWidget(
                        text: "Quality ON/OFF",
                      ),
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
                      const TextWidget(
                        text: "Subtitle ON/OFF",
                      ),
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
                      const TextWidget(
                        text: "Released By",
                      ),
                      heightBox5(),
                      TextFormFieldWidget(
                        focusNode: releasedByFocus,
                        controller: releasedByController,
                      ),
                      heightBox10(),
                      const TextWidget(
                        text: "Released Date",
                      ),
                      heightBox5(),
                      TextFormFieldWidget(
                        focusNode: releasedDateFocus,
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
                      const TextWidget(
                        text: "Highlighted",
                      ),
                      heightBox10(),
                      Switch(
                          activeColor: AppColors.zGreenColor,
                          value: isHighlighted,
                          onChanged: (v) {
                            setState(() {
                              isHighlighted = v;
                            });
                          }),
                      heightBox10(),
                      const TextWidget(
                        text: "Is Short Film On Rent",
                      ),
                      heightBox10(),
                      Switch(
                          activeColor: AppColors.zGreenColor,
                          value: isMovieOnRent,
                          onChanged: (v) {
                            setState(() {
                              isMovieOnRent = v;
                              showSubscription = false;
                            });
                          }),
                      heightBox10(),
                      if (isMovieOnRent)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextWidget(
                              text: "Movie Price",
                            ),
                            heightBox10(),
                            TextFormFieldWidget(
                              focusNode: moviePriceFocus,
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
                            const TextWidget(
                              text: "Rent Time Days",
                            ),
                            heightBox10(),
                            TextFormFieldWidget(
                              focusNode: rentedTimeDaysFocus,
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
                      const TextWidget(
                        text: "Status",
                      ),
                      heightBox10(),
                      Switch(
                          activeColor: AppColors.zGreenColor,
                          value: status,
                          onChanged: (v) {
                            setState(() {
                              status = v;
                            });
                          }),
                      heightBox10(),
                      heightBox10(),
                      const TextWidget(
                        text: "Show Subscription",
                      ),
                      heightBox10(),
                      Switch(
                          activeColor: AppColors.zGreenColor,
                          value: showSubscription,
                          onChanged: (v) {
                            showSubscription = v;
                            setState(() {});
                          }),
                      heightBox10(),
                      heightBox10(),
                      const TextWidget(
                        text: "Description",
                      ),
                      heightBox5(),
                      InkWell(
                        onTap: () {
                          releasedByFocus.unfocus();
                          releasedDateFocus.unfocus();
                          rentedTimeDaysFocus.unfocus();
                          movieNameFocus.unfocus();
                          moviePriceFocus.unfocus();
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
                      BlocConsumer<UpdateFilmCubit, UpdateFilmState>(
                        listener: (context, state) {
                          if (state is UpdateFilmLoadingState) {
                            Fluttertoast.showToast(msg: "It take time to update a shortfilm");
                          }
                          if (state is UpdateFilmErrorState) {
                            Fluttertoast.showToast(msg: state.error);
                            return;
                          }

                          if (state is UpdateFilmLoadedState) {
                            Fluttertoast.showToast(msg: "Update Sucessfully");
                            Navigator.pop(context);
                            context.read<GetAllShortFilmCubit>().getAllShortFilm();
                          }
                        },
                        builder: (context, updateState) {
                          return BlocConsumer<PostFilmCubit, PostFilmState>(
                            listener: (context, state) {
                              if (state is PostFilmLoadingState) {
                                Fluttertoast.showToast(msg: "It take time to upload a shortfilm");
                              }
                              if (state is PostFilmErrorState) {
                                Fluttertoast.showToast(msg: state.error);
                                return;
                              }

                              if (state is PostFilmLoadedState) {
                                Fluttertoast.showToast(msg: "Post Sucessfully");
                                Navigator.pop(context);
                                context.read<GetAllShortFilmCubit>().getAllShortFilm();
                              }
                            },
                            builder: (context, state) {
                              return CustomOutlinedButton(
                                inProgress: (state is PostFilmLoadingState || updateState is UpdateFilmLoadingState),
                                onPressed: () async {
                                  final contentData = await descriptionController.getText();
                                  final document = parse(contentData);
                                  final validHtml = document.outerHtml;
                                  log("Validated HTML: $validHtml");

                                  if (state is PostFilmLoadingState || updateState is UpdateFilmLoadingState) {
                                    return;
                                  }
                                  if (widget.id != null) {
                                    context.read<UpdateFilmCubit>().updateShortFilm(
                                          id: widget.id ?? "",
                                          coverImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                          description: validHtml,
                                          isMovieOnRent: isMovieOnRent,
                                          isHighlighted: isHighlighted,
                                          movieCategoryId: selectedCategoryId,
                                          movieLanguage: selectedLanguageId,
                                          genreId: seletedGenreId,
                                          movieName: movieNameController.text,
                                          subtitle: seelctedSubtitle == 'Yes' ? true : false,
                                          movieRentPrice: moviePriceController.text,
                                          movieTime: movieTimeController.text,
                                          showSubscription: showSubscription,
                                          movieVideo: _selectedVideo != null ? File(_selectedVideo!.path) : null,
                                          posterImg:
                                              _selectedPosterImage != null ? File(_selectedPosterImage!.path) : null,
                                          quality: selectedQuality == 'Yes' ? true : false,
                                          releasedBy: releasedByController.text,
                                          releasedDate: releasedDateController.text,
                                          status: status,
                                          // trailorVideo: _selectedTrailer != null ? File(_selectedTrailer!.path) : null,
                                          video_link: videoLinkController.text,
                                          rented_time_days: rentedTimeDaysController.text.isEmpty
                                              ? null
                                              : int.tryParse(rentedTimeDaysController.text),
                                        );
                                    return;
                                  }

                                  if (selectedCategory == null) {
                                    Fluttertoast.showToast(msg: "Select Movie Category");
                                    return;
                                  }

                                  // if (selectedGenre == null) {
                                  //   Fluttertoast.showToast(msg: "Select Movie Genre");
                                  //   return;
                                  // }

                                  if (selectedLanguage == null) {
                                    Fluttertoast.showToast(msg: "Select Movie Langiage");
                                    return;
                                  }

                                  if (movieNameController.text.isEmpty) {
                                    Fluttertoast.showToast(msg: "Movie Name is required");
                                    return;
                                  }
                                  if (selectedLanguage == null) {
                                    Fluttertoast.showToast(msg: "Movie Language is required");
                                    return;
                                  }
                                  // if (selectedGenre == null) {
                                  //   Fluttertoast.showToast(msg: "Genre is required");
                                  //   return;
                                  // }
                                  if (movieTimeController.text.isEmpty) {
                                    Fluttertoast.showToast(msg: "Movie Time is required");
                                    return;
                                  }
                                  if (releasedByController.text.isEmpty) {
                                    Fluttertoast.showToast(msg: "Released By is required");
                                    return;
                                  }
                                  if (releasedDateController.text.isEmpty) {
                                    Fluttertoast.showToast(msg: "Released Date is required");
                                    return;
                                  }
                                  if (await descriptionController.getText() == '') {
                                    Fluttertoast.showToast(msg: "Description is required");
                                    return;
                                  }

                                  if (_selectedVideo == null && videoLinkController.text.isEmpty) {
                                    Fluttertoast.showToast(msg: "Video file or video link is required");
                                    return;
                                  }

                                  context.read<PostFilmCubit>().postShortFilm(
                                        coverImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                        description: validHtml,
                                        isHighlighted: isHighlighted,
                                        movieCategoryId: selectedCategoryId,
                                        movieLanguage: selectedLanguageId,
                                        genreId: seletedGenreId,
                                        movieName: movieNameController.text,
                                        subtitle: seelctedSubtitle == 'Yes' ? true : false,
                                        movieRentPrice: moviePriceController.text,
                                        showSubscription: showSubscription,
                                        movieTime: movieTimeController.text,
                                        movieVideo: _selectedVideo != null ? File(_selectedVideo!.path) : null,
                                        // trailorVideo: _selectedTrailer != null ? File(_selectedTrailer!.path) : null,
                                        posterImg:
                                            _selectedPosterImage != null ? File(_selectedPosterImage!.path) : null,
                                        quality: selectedQuality == 'Yes' ? true : false,
                                        releasedBy: releasedByController.text,
                                        releasedDate: releasedDateController.text,
                                        status: status,
                                        isMovieOnRent: isMovieOnRent,
                                        video_link: videoLinkController.text,
                                        rented_time_days: rentedTimeDaysController.text.isEmpty
                                            ? null
                                            : int.tryParse(rentedTimeDaysController.text),
                                      );
                                },
                                buttonText: widget.id != null ? "Save Short Film" : "Upload Short Film",
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
