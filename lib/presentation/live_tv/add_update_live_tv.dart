import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elite_admin/bloc/livetv/category/get_live_category/get_live_category_cubit.dart';
import 'package:elite_admin/bloc/livetv/create/create_live_tv/createlivetv_cubit.dart';
import 'package:elite_admin/bloc/livetv/create/get_live_tv/get_live_tv_cubit.dart';
import 'package:elite_admin/bloc/livetv/create/get_live_tv/get_live_tv_model.dart';
import 'package:elite_admin/bloc/livetv/create/update_live_tv/update_live_tv_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/constant/image_picker_utils.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_dropdown.dart';
import 'package:elite_admin/utils/widget/custom_editor.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class AddUpdateLiveTvScreen extends StatefulWidget {
  const AddUpdateLiveTvScreen({super.key, this.id, this.model});
  final String? id;
  final Channel? model;

  @override
  State<AddUpdateLiveTvScreen> createState() => _AddUpdateLiveTvScreenState();
}

class _AddUpdateLiveTvScreenState extends State<AddUpdateLiveTvScreen> with Utility {
  XFile? _selectedImage;
  XFile? _selectedPosterImage;
  String? selectedLanguage;
  String? selectedLanguageId;
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

  Future<void> _pickPosterImage() async {
    final pickedFile = await ImagePickerUtil.pickImageFromGallery();
    if (pickedFile != null) {
      setState(() {
        _selectedPosterImage = pickedFile;
      });
    }
  }

  final HtmlEditorController descriptionController = HtmlEditorController();
  final nameController = TextEditingController();
  final androidUrlController = TextEditingController();
  final iosUrlController = TextEditingController();

  final nameFocus = FocusNode();
  final androidUrlFocus = FocusNode();
  final iosUrlFocus = FocusNode();
  bool status = false;
  bool showSubscrption = false;

  @override
  void dispose() {
    nameController.dispose();
    androidUrlController.dispose();
    iosUrlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.model != null) {
      nameController.text = widget.model?.name ?? "";
      androidUrlController.text = widget.model?.androidChannelUrl ?? "";
      iosUrlController.text = widget.model?.iosChannelUrl ?? "";
      status = widget.model?.status ?? false;
      showSubscrption = widget.model?.is_livetv_on_rent ?? false;
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
                  text: widget.id != null ? "Update Live TV" : "Add Live TV",
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
                        text: "Select Live Category Id",
                      ),
                      heightBox5(),
                      BlocBuilder<GetLiveCategoryCubit, GetLiveCategoryState>(
                        builder: (context, state) {
                          if (state is GetLiveCategoryLoadedState) {
                            final languageNames =
                                state.model.data?.categories?.map((datum) => datum.name).whereType<String>().toList() ??
                                    [];
                            return CustomDropdown(
                              items: languageNames,
                              hinttext: "select language",
                              selectedValue: selectedLanguage,
                              onChanged: (value) {
                                setState(() {
                                  selectedLanguage = value;
                                  final selectedDatum =
                                      state.model.data?.categories?.firstWhere((datum) => datum.name == value);
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
                        text: "Live TV Name",
                      ),
                      heightBox5(),
                      TextFormFieldWidget(
                        focusNode: nameFocus,
                        controller: nameController,
                      ),
                      heightBox10(),
                      const TextWidget(
                        text: "Android Channel Url",
                      ),
                      heightBox5(),
                      TextFormFieldWidget(
                        focusNode: androidUrlFocus,
                        controller: androidUrlController,
                      ),
                      heightBox10(),
                      const TextWidget(
                        text: "IOS Channel Url",
                      ),
                      heightBox5(),
                      TextFormFieldWidget(
                        focusNode: iosUrlFocus,
                        controller: iosUrlController,
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
                      const TextWidget(
                        text: "Show Subscrpiton",
                      ),
                      heightBox10(),
                      Switch(
                          activeColor: AppColors.zGreenColor,
                          value: showSubscrption,
                          onChanged: (v) {
                            setState(() {
                              showSubscrption = v;
                            });
                          }),
                      heightBox10(),
                      const TextWidget(
                        text: "Description",
                      ),
                      heightBox5(),
                      SizedBox(
                        height: 500,
                        child: InkWell(
                          onTap: () {
                            nameFocus.unfocus();
                            androidUrlFocus.unfocus();
                            iosUrlFocus.unfocus();
                          },
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
                      BlocConsumer<UpdateLiveTvCubit, UpdateLiveTvState>(
                        listener: (context, state) {
                          if (state is UpdateLiveTvErrorState) {
                            Fluttertoast.showToast(msg: state.error);
                            return;
                          }

                          if (state is UpdateLiveTvLoadedState) {
                            Fluttertoast.showToast(msg: "Update Sucessfully");
                            Navigator.pop(context);
                            context.read<GetLiveTvCubit>().getAllLiveCategory();
                          }
                        },
                        builder: (context, updateState) {
                          return BlocConsumer<CreatelivetvCubit, CreatelivetvState>(
                            listener: (context, state) {
                              if (state is CreatelivetvErrorState) {
                                Fluttertoast.showToast(msg: state.error);
                                return;
                              }

                              if (state is CreatelivetvLoadedState) {
                                Fluttertoast.showToast(msg: "Post Sucessfully");
                                Navigator.pop(context);
                                context.read<GetLiveTvCubit>().getAllLiveCategory();
                              }
                            },
                            builder: (context, state) {
                              return CustomOutlinedButton(
                                inProgress:
                                    (state is CreatelivetvLoadingState || updateState is UpdateLiveTvLoadingState),
                                onPressed: () async {
                                  final contentData = await descriptionController.getText();
                                  final document = parse(contentData);
                                  final validHtml = document.outerHtml;
                                  log("Validated HTML: $validHtml");

                                  if (state is CreatelivetvLoadingState || updateState is UpdateLiveTvLoadingState) {
                                    return;
                                  }
                                  if (widget.id != null) {
                                    context.read<UpdateLiveTvCubit>().updateLiveTV(
                                          id: widget.id ?? "",
                                          coverImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                          description: validHtml,
                                          posterImg:
                                              _selectedPosterImage != null ? File(_selectedPosterImage!.path) : null,
                                          status: status,
                                          androidChannelUrl: androidUrlController.text,
                                          iosChannelUrl: iosUrlController.text,
                                          liveCategoryId: selectedLanguageId,
                                          name: nameController.text,
                                          is_livetv_on_rent: showSubscrption
                                        );
                                    return;
                                  }

                                  if (selectedLanguageId == null) {
                                    Fluttertoast.showToast(msg: "Select Live TV Category");
                                    return;
                                  }

                                  if (nameController.text.isEmpty) {
                                    Fluttertoast.showToast(msg: "Name is required");
                                    return;
                                  }
                                  if (androidUrlController.text.isEmpty) {
                                    Fluttertoast.showToast(msg: "Android Url is required");
                                    return;
                                  }
                                  if (iosUrlController.text.isEmpty) {
                                    Fluttertoast.showToast(msg: "Ios Url is required");
                                    return;
                                  }
                                  if (selectedLanguage == null) {
                                    Fluttertoast.showToast(msg: "Movie Language is required");
                                    return;
                                  }

                                  context.read<CreatelivetvCubit>().createLiveTV(
                                        coverImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                        description: validHtml,
                                        posterImg:
                                            _selectedPosterImage != null ? File(_selectedPosterImage!.path) : null,
                                        status: status,
                                        androidChannelUrl: androidUrlController.text,
                                        iosChannelUrl: iosUrlController.text,
                                        liveCategoryId: selectedLanguageId,
                                        name: nameController.text,
                                        is_livetv_on_rent: showSubscrption,
                                      );
                                },
                                buttonText: widget.id != null ? "Save Live TV" : "Upload Live TV",
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
