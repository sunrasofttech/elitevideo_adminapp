import 'dart:developer';
import 'dart:io';
import 'package:elite_admin/utils/toast.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elite_admin/bloc/movie/category/get_all_category/get_all_category_cubit.dart';
import 'package:elite_admin/bloc/movie/genre/get_all_genre/get_all_genre_cubit.dart';
import 'package:elite_admin/bloc/movie/language/get_all_language/get_all_language_cubit.dart';
import 'package:elite_admin/bloc/web_series/series/get_all_series/get_all_Series_model.dart';
import 'package:elite_admin/bloc/web_series/series/get_all_series/get_all_series_cubit.dart';
import 'package:elite_admin/bloc/web_series/series/post_series/post_series_cubit.dart';
import 'package:elite_admin/bloc/web_series/series/update_series/update_series_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/constant/image_picker_utils.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_dropdown.dart';
import 'package:elite_admin/utils/widget/custom_editor.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class AddUpdateSeriesScreen extends StatefulWidget {
  const AddUpdateSeriesScreen({super.key, this.id, this.item});
  final String? id;
  final Datum? item;

  @override
  State<AddUpdateSeriesScreen> createState() => _AddUpdateSeriesScreenState();
}

class _AddUpdateSeriesScreenState extends State<AddUpdateSeriesScreen> with Utility {
  String? selectedLanguage;
  String? selectedLanguageId;

  String? selectedGenre;
  String? seletedGenreId;

  String? selectedCategory;
  String? selectedCategoryId;

  XFile? _selectedCoverImage;
  XFile? _selectedPosterImage;
  bool status = false;

  final HtmlEditorController descriptionController = HtmlEditorController();
  TextEditingController movieNameController = TextEditingController();
  final releasedByController = TextEditingController();
  TextEditingController releasedDateController = TextEditingController();
  TextEditingController seriesRentPriceController = TextEditingController();
  TextEditingController rentedTimeDaysController = TextEditingController();
  TextEditingController moviePriceController = TextEditingController();
  bool isMovieOnRent = false;
  bool showSubscription = true;
  final FocusNode movieNameFocusNode = FocusNode();
  final FocusNode releasedByFocusNode = FocusNode();
  final FocusNode releasedDateFocusNode = FocusNode();
  final FocusNode rentedTimeFocusNode = FocusNode();
  final FocusNode rentPriceFocusNode = FocusNode();

  final FocusNode descriptionFocusNode = FocusNode();
  final TextEditingController descriptionTextController = TextEditingController();

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

  Future<void> _pickCoverImage() async {
    final pickedFile = await ImagePickerUtil.pickImageFromGallery(
      context: context,
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
      initAspectRatio: CropAspectRatioPreset.square,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedCoverImage = pickedFile;
      });
    }
  }

  @override
  void initState() {
    if (widget.item != null) {
      var data = widget.item;
      movieNameController.text = data?.seriesName ?? "";
      releasedByController.text = data?.releasedBy ?? "";
      releasedDateController.text = (data?.releasedDate != null) ? data!.releasedDate.toString() : "";
      status = data?.status ?? false;
      isMovieOnRent = data?.isSeriesOnRent ?? false;
      showSubscription = data?.showSubscription ?? false;
      seriesRentPriceController.text = data?.seriesRentPrice ?? '';
      rentedTimeDaysController.text = data?.rentedTimeDays.toString() ?? "";
      if (Platform.isWindows) {
        final rawHtml = data?.description ?? "";
        final document = html_parser.parse(rawHtml);
        final cleanText = document.body?.text ?? "";
        descriptionTextController.text = cleanText.trim();
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    movieNameController.dispose();
    releasedByController.dispose();
    releasedDateController.dispose();
    movieNameFocusNode.dispose();
    releasedByFocusNode.dispose();
    releasedDateFocusNode.dispose();
    super.dispose();
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
                heightBox30(),
                TextWidget(
                  text: widget.id != null ? "Update Series" : "Add Series",
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
                        onTap: _pickCoverImage,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(color: AppColors.greyColor),
                          ),
                          child: _selectedCoverImage == null
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
                                    File(_selectedCoverImage!.path),
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
                      const TextWidget(text: "Select Category"),
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
                      const TextWidget(text: "Web Series Name"),
                      heightBox5(),
                      TextFormFieldWidget(focusNode: movieNameFocusNode, controller: movieNameController),
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
                      const TextWidget(text: "Is Short Film On Rent"),
                      heightBox10(),
                      Switch(
                        activeColor: AppColors.zGreenColor,
                        value: isMovieOnRent,
                        onChanged: (v) {
                          setState(() {
                            isMovieOnRent = v;
                          });
                        },
                      ),
                      heightBox10(),
                      if (isMovieOnRent)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextWidget(text: "Series Price"),
                            heightBox10(),
                            TextFormFieldWidget(
                              focusNode: rentPriceFocusNode,
                              controller: seriesRentPriceController,
                              hintText: "Series price",
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
                      const TextWidget(text: "Description"),
                      heightBox5(),
                      InkWell(
                        onTap: () {
                          movieNameFocusNode.unfocus();
                          releasedByFocusNode.unfocus();
                          releasedDateFocusNode.unfocus();
                          rentedTimeFocusNode.unfocus();
                          rentPriceFocusNode.unfocus();
                        },
                        child: SizedBox(
                          height: Platform.isWindows ? null : 500,
                          child: Platform.isWindows
                              ? TextField(
                                  controller: descriptionTextController,
                                  focusNode: descriptionFocusNode,
                                  maxLines: 12,
                                  decoration: InputDecoration(
                                    hintText: "Enter movie description",
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
                                  htmlContent: widget.item?.description ?? "",
                                ),
                        ),
                      ),
                      BlocConsumer<UpdateSeriesCubit, UpdateSeriesState>(
                        listener: (context, state) {
                          if (state is UpdateSeriesErrorState) {
                            showMessage(context, state.error);
                            return;
                          }

                          if (state is UpdateSeriesLoadedState) {
                            Navigator.pop(context);
                            showMessage(context, "Update Successfully");
                            context.read<GetAllSeriesCubit>().getAllSeries();
                          }
                        },
                        builder: (context, updateState) {
                          return BlocConsumer<PostSeriesCubit, PostSeriesState>(
                            listener: (context, state) {
                              if (state is PostSeriesErrorState) {
                                showMessage(context, state.error);
                                return;
                              }

                              if (state is PostSeriesLoadedState) {
                                showMessage(context, "Post Sucessdfully ✅");
                                Navigator.pop(context);
                                context.read<GetAllSeriesCubit>().getAllSeries();
                              }
                            },
                            builder: (context, state) {
                              int? progressPercent;
                              if (state is PostSeriesProgressState) {
                                progressPercent = state.percent;
                              }

                              if (updateState is UpdateSeriesProgressState) {
                                progressPercent = updateState.percent;
                              }
                              return CustomOutlinedButton(
                                progress: progressPercent,
                                inProgress:
                                    (updateState is UpdateSeriesLoadingState ||
                                    state is PostSeriesLoadingState ||
                                    updateState is UpdateSeriesProgressState ||
                                    state is PostSeriesProgressState),
                                onPressed: () async {
                                  var validHtml;
                                  try {
                                    final contentData = await descriptionController.getText();
                                    final document = parse(contentData);
                                    validHtml = document.outerHtml;
                                    log(
                                      "Validated HTML: $validHtml ${rentedTimeDaysController.text.runtimeType} ${rentedTimeDaysController.text.isEmpty} ${rentedTimeDaysController.text.length} ${rentedTimeDaysController.text}",
                                    );
                                  } catch (e) {}
                                  if (widget.id != null) {
                                    context.read<UpdateSeriesCubit>().updateSeries(
                                      id: widget.id ?? "",
                                      coverImg: _selectedPosterImage != null ? File(_selectedPosterImage!.path) : null,
                                      description: validHtml ?? "",
                                      genreId: seletedGenreId,
                                      movieCategoryId: selectedCategoryId,
                                      movieLanguage: selectedLanguageId,
                                      movieName: movieNameController.text,
                                      posterImg: _selectedPosterImage != null ? File(_selectedPosterImage!.path) : null,
                                      releasedBy: releasedByController.text,
                                      releasedDate: releasedDateController.text,
                                      status: status,
                                      isSeriesOnRent: isMovieOnRent,
                                      rentedTimeDays:
                                          (rentedTimeDaysController.text.isEmpty ||
                                              rentedTimeDaysController.text.contains('null'))
                                          ? null
                                          : rentedTimeDaysController.text,
                                      seriesRentPrice: seriesRentPriceController.text,
                                      showSubscription: showSubscription,
                                    );
                                    return;
                                  }

                                  if (_selectedPosterImage == null) {
                                    showMessage(context, "Upload Poster Image");
                                    return;
                                  }

                                  if (selectedCategoryId == null) {
                                    showMessage(context, "Select Category");
                                    return;
                                  }

                                  if (selectedLanguageId == null) {
                                    showMessage(context, "Select Language");
                                    return;
                                  }

                                  if (movieNameController.text.isEmpty) {
                                    showMessage(context, "please enter movie name");
                                    return;
                                  }

                                  if (_selectedPosterImage == null) {
                                    showMessage(context, "upload poster is required");
                                    return;
                                  }

                                  context.read<PostSeriesCubit>().postSeries(
                                    coverImg: _selectedPosterImage != null ? File(_selectedPosterImage!.path) : null,
                                    description: validHtml ?? "",
                                    genreId: seletedGenreId,
                                    movieCategoryId: selectedCategoryId,
                                    movieLanguage: selectedLanguageId,
                                    movieName: movieNameController.text,
                                    posterImg: _selectedPosterImage != null ? File(_selectedPosterImage!.path) : null,
                                    releasedBy: releasedByController.text,
                                    releasedDate: releasedDateController.text,
                                    status: status,
                                    isSeriesOnRent: isMovieOnRent,
                                    rentedTimeDays: rentedTimeDaysController.text,
                                    seriesRentPrice: seriesRentPriceController.text,
                                    showSubscription: showSubscription,
                                  );
                                },
                                buttonText: widget.id != null ? "Save Web Series" : "Upload Web Series",
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
