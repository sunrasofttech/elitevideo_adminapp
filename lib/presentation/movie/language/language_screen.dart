import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:elite_admin/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elite_admin/bloc/movie/language/delete_language/delete_language_cubit.dart';
import 'package:elite_admin/bloc/movie/language/get_all_language/get_all_language_cubit.dart';
import 'package:elite_admin/bloc/movie/language/post_language/post_language_cubit.dart';
import 'package:elite_admin/bloc/movie/language/update_language/update_language_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/constant/image_picker_utils.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_empty_widget.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/delete_dialog.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> with Utility {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextWidget(text: "Language", fontSize: 15, fontWeight: FontWeight.w600),
              heightBox15(),
              Row(
                children: [
                  Expanded(
                    child: TextFormFieldWidget(
                      controller: searchController,
                      isSuffixIconShow: true,
                      onChanged: (p0) {
                        context.read<GetAllLanguageCubit>().getAllLanguage(name: p0);
                      },
                      suffixIcon: const Icon(Icons.search, color: AppColors.blackColor),
                    ),
                  ),
                  widthBox10(),
                  InkWell(
                    onTap: () {
                      _addUpdateLanguagePopUp();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        gradient: LinearGradient(colors: AppColors.blueGradientList),
                      ),
                      child: Row(
                        children: [
                          const TextWidget(text: "Add", color: AppColors.whiteColor),
                          widthBox5(),
                          const Icon(Icons.add_circle_rounded, color: AppColors.whiteColor),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              heightBox20(),
              BlocListener<UpdateLanguageCubit, UpdateLanguageState>(
                listener: (context, state) {
                  if (state is UpdateLanguageErrorState) {
                   showMessage(context, state.error);
                    return;
                  }
                  if (state is UpdateLanguageLoadedState) {
                   showMessage(context, "Update Sucessfully");
                    context.read<GetAllLanguageCubit>().getAllLanguage();
                  }
                },
                child: BlocListener<DeleteLanguageCubit, DeleteLanguageState>(
                  listener: (context, state) {
                    if (state is DeleteLanguageErrorState) {
                     showMessage(context, state.error);
                      return;
                    }

                    if (state is DeleteLanguageLoadedState) {
                     showMessage(context, "Delete Sucessfully");
                      Navigator.pop(context);
                      context.read<GetAllLanguageCubit>().getAllLanguage();
                    }
                  },
                  child: BlocBuilder<GetAllLanguageCubit, GetAllLanguageState>(
                    builder: (context, state) {
                      if (state is GetAllLanguageLoadingState) {
                        return const Center(child: CustomCircularProgressIndicator());
                      }

                      if (state is GetAllLanguageErrorState) {
                        return const Center(child: CustomErrorWidget());
                      }

                      if (state is GetAllLanguageLoadedState) {
                        return state.model.data?.isEmpty ?? true
                            ? const Center(child: CustomEmptyWidget())
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var data = state.model.data?[index];
                                  return Card(
                                    color: AppColors.whiteColor,
                                    surfaceTintColor: AppColors.whiteColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: "${AppUrls.baseUrl}/${data?.coverImg ?? ""}",
                                            height: 70,
                                            width: 70,
                                            errorWidget: (context, url, error) {
                                              return const Icon(Icons.gps_not_fixed_outlined);
                                            },
                                          ),
                                          widthBox10(),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextWidget(
                                                  text: "${data?.name}",
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                const SizedBox(height: 4),
                                              ],
                                            ),
                                          ),
                                          // Actions Section
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      _addUpdateLanguagePopUp(
                                                        id: data?.id,
                                                        title: data?.name,
                                                        status: data?.status,
                                                      );
                                                    },
                                                    child: svgAsset(assetName: AppImages.editSvg),
                                                  ),
                                                  widthBox5(),
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return DeleteDialog(
                                                            onCancelPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            onDeletePressed: () {
                                                              context.read<DeleteLanguageCubit>().deleteLanguage(
                                                                data?.id ?? "",
                                                              );
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: svgAsset(assetName: AppImages.deleteSvg),
                                                  ),
                                                ],
                                              ),
                                              Switch(
                                                activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                thumbColor: const WidgetStatePropertyAll(
                                                  Color.fromRGBO(65, 160, 255, 1),
                                                ),
                                                value: data?.status ?? false,
                                                onChanged: (value) {
                                                  context.read<UpdateLanguageCubit>().updateLanguage(
                                                    id: data?.id,
                                                    status: value,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: state.model.data?.length,
                              );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addUpdateLanguagePopUp({String? id, bool? status, String? title}) {
    final titleController = TextEditingController(text: title);
    bool isActive = status ?? false;
    XFile? _selectedImage;

    Future<void> _pickImage(setState) async {
      final pickedFile = await ImagePickerUtil.pickImageFromGallery();
      if (pickedFile != null) {
        setState(() {
          _selectedImage = pickedFile;
        });
      }
    }

    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (context, setState) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextWidget(text: "Language Title", fontWeight: FontWeight.w700, fontSize: 15),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: AppColors.greyColor,
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                              ),
                              child: const Icon(Icons.close, color: AppColors.whiteColor),
                            ),
                          ),
                        ],
                      ),
                      heightBox15(),
                      const TextWidget(text: "Language Title", color: AppColors.blackColor),
                      heightBox10(),
                      TextFormFieldWidget(controller: titleController),
                      heightBox10(),
                      const TextWidget(text: "Image", color: AppColors.blackColor),
                      heightBox10(),
                      GestureDetector(
                        onTap: () => _pickImage(setState),
                        child: Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade100,
                          ),
                          child: _selectedImage == null
                              ? const Center(
                                  child: Text("Tap to select image", style: TextStyle(color: Colors.grey)),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(_selectedImage!.path),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                        ),
                      ),
                      const TextWidget(text: "Status"),
                      heightBox10(),
                      Switch(
                        activeColor: AppColors.zGreenColor,
                        value: isActive,
                        onChanged: (value) {
                          setState(() {
                            isActive = value;
                          });
                        },
                      ),
                      heightBox10(),
                      BlocConsumer<UpdateLanguageCubit, UpdateLanguageState>(
                        listener: (context, state) {
                          if (state is UpdateLanguageErrorState) {
                           showMessage(context, state.error);
                            return;
                          }

                          if (state is UpdateLanguageLoadedState) {
                           showMessage(context, "Update Sucessfully");
                            context.read<GetAllLanguageCubit>().getAllLanguage();
                            Navigator.pop(context);
                          }
                        },
                        builder: (context, updateState) {
                          return BlocConsumer<PostLanguageCubit, PostLanguageState>(
                            listener: (context, state) {
                              if (state is PostLanguageErrorState) {
                               showMessage(context, state.error);
                                return;
                              }

                              if (state is PostLanguageLoadedState) {
                               showMessage(context, "Post Sucessfully");
                                context.read<GetAllLanguageCubit>().getAllLanguage();
                                Navigator.pop(context);
                              }
                            },
                            builder: (context, state) {
                              return CustomOutlinedButton(
                                inProgress:
                                    (state is PostLanguageLoadingState || updateState is UpdateLanguageLoadingState),
                                onPressed: () {
                                  if (id != null) {
                                    context.read<UpdateLanguageCubit>().updateLanguage(
                                      id: id,
                                      name: titleController.text,
                                      status: isActive,
                                      coverImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                    );
                                    return;
                                  }

                                  context.read<PostLanguageCubit>().postLanguage(
                                    name: titleController.text,
                                    status: isActive,
                                    coverImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                  );
                                },
                                buttonText: id != null ? 'Save Language' : 'Add Language',
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
