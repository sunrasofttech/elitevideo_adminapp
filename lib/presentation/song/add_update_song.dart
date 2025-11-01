import 'dart:developer';
import 'dart:io';
import 'package:elite_admin/utils/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:html/parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elite_admin/bloc/movie/language/get_all_language/get_all_language_cubit.dart';
import 'package:elite_admin/bloc/music/artist/get_artist/get_artist_cubit.dart';
import 'package:elite_admin/bloc/music/category/get_all_music_category/get_all_music_category_cubit.dart';
import 'package:elite_admin/bloc/music/upload_music/create_music/create_music_cubit.dart';
import 'package:elite_admin/bloc/music/upload_music/get_all_music/get_all_music_cubit.dart';
import 'package:elite_admin/bloc/music/upload_music/update_music/update_music_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/constant/image_picker_utils.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_dropdown.dart';
import 'package:elite_admin/utils/widget/custom_editor.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

import '../../bloc/music/upload_music/get_all_music/get_all_music_model.dart';

class AddUpdateSongScreen extends StatefulWidget {
  const AddUpdateSongScreen({super.key, this.id, this.data});
  final String? id;
  final Item? data;

  @override
  State<AddUpdateSongScreen> createState() => _AddUpdateSongScreenState();
}

class _AddUpdateSongScreenState extends State<AddUpdateSongScreen> with Utility {
  String? selectedCategory;
  String? selectedCategoryId;

  String? selectedArtist;
  String? selectedArtistId;

  String? selectedLanguage;
  String? selectedLanguageId;

  XFile? _selectedCoverImage;
  PlatformFile? _selectedSong;

  bool status = false;
  bool isPopular = false;

  final HtmlEditorController descriptionController = HtmlEditorController();
  final songTitleController = TextEditingController();
  final TextEditingController descriptionTextController = TextEditingController();
  final FocusNode descriptionFocusNode = FocusNode();
  final songArtistController = TextEditingController();

  Future<void> _pickImage() async {
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

  Future<void> _pickSong() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedSong = result.files.first;
      });
    } else {
      showMessage(context, "No audio file selected.");
    }
  }

  @override
  void dispose() {
    descriptionController.clear();
    songTitleController.dispose();
    songArtistController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.data != null) {
      songTitleController.text = widget.data?.songTitle ?? "";
      songArtistController.text = widget.data?.artistName ?? "";
      status = widget.data?.status ?? false;
      isPopular = widget.data?.isPopular ?? false;
      if (Platform.isWindows) {
        final rawHtml = widget.data?.description ?? "";
        final document = html_parser.parse(rawHtml);
        final cleanText = document.body?.text ?? "";
        descriptionTextController.text = cleanText.trim();
      }
      setState(() {});
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
                heightBox15(),
                TextWidget(
                  text: widget.id != null ? "Update Song" : "Add Songs",
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
                      heightBox10(),
                      const TextWidget(text: "Song Title"),
                      heightBox5(),
                      TextFormFieldWidget(controller: songTitleController),
                      heightBox10(),
                      const TextWidget(text: "Song Artist Name"),
                      heightBox5(),
                      BlocBuilder<GetArtistCubit, GetArtistState>(
                        builder: (context, state) {
                          if (state is GetArtistLoadedState) {
                            final genres =
                                state.model.data?.map((datum) => datum.artistName).whereType<String>().toList() ?? [];
                            return CustomDropdown(
                              items: genres,
                              selectedValue: selectedArtist,
                              onChanged: (value) {
                                selectedArtist = value;

                                final selectedArtists = state.model.data?.firstWhere(
                                  (datum) => datum.artistName == value,
                                );
                                songArtistController.text = selectedArtists?.artistName ?? "";
                                selectedArtistId = selectedArtists?.id;
                                print("Selected Datum ID: ${selectedArtists?.id}");
                                setState(() {});
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      heightBox10(),
                      const TextWidget(text: "Song Language"),
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
                      const TextWidget(text: "Select Movie Category"),
                      heightBox5(),
                      BlocBuilder<GetAllMusicCategoryCubit, GetAllMusicCategoryState>(
                        builder: (context, state) {
                          if (state is GetAllMusicCategoryLoadedState) {
                            final genres =
                                state.model.data?.map((datum) => datum.name).whereType<String>().toList() ?? [];
                            return CustomDropdown(
                              items: genres,
                              selectedValue: selectedCategory,
                              onChanged: (value) {
                                selectedCategory = value;
                                final selectedDatum = state.model.data?.firstWhere((datum) => datum.name == value);
                                selectedCategoryId = selectedDatum?.id;
                                print("Selected Datum ID: ${selectedDatum?.id}");
                                setState(() {});
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      heightBox10(),
                      const TextWidget(text: "song"),
                      heightBox5(),
                      _selectedSong != null
                          ? Text("Selected song: ${_selectedSong!.name}")
                          : const Text("No song selected."),
                      heightBox5(),
                      CustomOutlinedButton(onPressed: _pickSong, buttonText: "Pick song"),
                      heightBox10(),
                      const TextWidget(text: "Description"),
                      heightBox5(),
                      SizedBox(
                        height: Platform.isWindows ? null : 500,
                        child: Platform.isWindows
                            ? TextField(
                                controller: descriptionTextController,
                                focusNode: descriptionFocusNode,
                                maxLines: 12,
                                decoration: InputDecoration(
                                  hintText: "Enter song description",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                              )
                            : CustomHtmlEditor(
                                hint: "",
                                onPressed: () async {},
                                controller: descriptionController,
                                htmlContent: widget.data?.description ?? "",
                              ),
                      ),
                      heightBox10(),
                      const TextWidget(text: "Popular"),
                      heightBox10(),
                      Switch(
                        activeColor: AppColors.zGreenColor,
                        value: isPopular,
                        onChanged: (v) {
                          setState(() {
                            isPopular = v;
                          });
                        },
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
                      BlocConsumer<UpdateMusicCubit, UpdateMusicState>(
                        listener: (context, state) {
                          if (state is UpdateMusicLoadedState) {
                            showMessage(context, "Update successfully");
                            context.read<GetAllMusicCubit>().getAllMusic();
                            Navigator.pop(context);
                          }

                          if (state is UpdateMusicErrorState) {
                            showMessage(context, "${state.error}.");
                          }
                        },
                        builder: (context, updateState) {
                          return BlocConsumer<CreateMusicCubit, CreateMusicState>(
                            listener: (context, state) {
                              if (state is CreateMusicErrorState) {
                                showMessage(context, state.error);
                              }

                              if (state is CreateMusicLoadedState) {
                                Navigator.pop(context);
                                context.read<GetAllMusicCubit>().getAllMusic();
                                showMessage(context, "music added Successfully");
                              }
                            },
                            builder: (context, state) {
                              int? progressPercent;
                              if (state is CreateMusicProgressState) {
                                progressPercent = state.percent;
                              }

                              if (updateState is UpdateMusicProgressState) {
                                progressPercent = updateState.percent;
                              }
                              return CustomOutlinedButton(
                                progress: progressPercent,
                                inProgress:
                                    (updateState is UpdateMusicLoadingState ||
                                    state is CreateMusicLoadingState ||
                                    state is CreateMusicProgressState ||
                                    updateState is UpdateMusicProgressState),
                                onPressed: () async {
                                  if (updateState is UpdateMusicLoadingState ||
                                      state is CreateMusicLoadingState ||
                                      state is CreateMusicProgressState ||
                                      updateState is UpdateMusicProgressState) {
                                    return;
                                  }
                                  var validHtml;
                                  try {
                                    final contentData = Platform.isWindows
                                        ? descriptionTextController.text
                                        : await descriptionController.getText();
                                    final document = parse(contentData);
                                    validHtml = document.outerHtml;
                                    log("Validated HTML: $validHtml   $selectedArtistId");
                                  } catch (e) {}
                                  if (widget.id != null) {
                                    context.read<UpdateMusicCubit>().updateMusic(
                                      id: widget.id ?? "",
                                      artistName: songArtistController.text,
                                      coverImg: _selectedCoverImage != null ? File(_selectedCoverImage!.path) : null,
                                      description: validHtml ?? "",
                                      musicName: songTitleController.text,
                                      songFile: _selectedSong != null ? File(_selectedSong!.path ?? "") : null,
                                      status: status,
                                      artistId: selectedArtistId,
                                      isPopular: isPopular,
                                      languageId: selectedLanguageId,
                                    );
                                    return;
                                  }

                                  if (songArtistController.text.isEmpty) {
                                    showMessage(context, "Please add artist name");
                                    return;
                                  }

                                  if (songTitleController.text.isEmpty) {
                                    showMessage(context, "Please add song title");
                                    return;
                                  }

                                  if (_selectedCoverImage == null) {
                                    showMessage(context, "Please select a cover image");
                                    return;
                                  }

                                  if (_selectedSong == null || _selectedSong!.path!.isEmpty) {
                                    showMessage(context, "Please select a song file");
                                    return;
                                  }

                                  if (selectedCategoryId == null || selectedCategoryId!.isEmpty) {
                                    showMessage(context, "Please select a category");
                                    return;
                                  }

                                  if (selectedArtistId == null) {
                                    showMessage(context, "Please select a artist name");
                                    return;
                                  }

                                  if (selectedLanguageId == null || selectedLanguageId!.isEmpty) {
                                    showMessage(context, "Please select a language id");
                                    return;
                                  }

                                  context.read<CreateMusicCubit>().createMusic(
                                    artistName: songArtistController.text,
                                    coverImg: _selectedCoverImage != null ? File(_selectedCoverImage!.path) : null,
                                    description: validHtml ?? "",
                                    musicName: songTitleController.text,
                                    songFile: _selectedSong != null ? File(_selectedSong!.path ?? "") : null,
                                    status: status,
                                    categoryId: selectedCategoryId,
                                    artistId: selectedArtistId,
                                    isPopular: isPopular,
                                    languageId: selectedLanguageId,
                                  );
                                },
                                buttonText: widget.id != null ? "Save Song" : "Upload Song",
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
                heightBox30(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
