import 'dart:io';

import 'package:elite_admin/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elite_admin/bloc/livetv/category/create_live_category/create_live_category_cubit.dart';
import 'package:elite_admin/bloc/livetv/category/delete_live_category/delete_live_category_cubit.dart';
import 'package:elite_admin/bloc/livetv/category/get_live_category/get_live_category_cubit.dart';
import 'package:elite_admin/bloc/livetv/category/update_live_category/update_live_category_cubit.dart';
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

class LiveTvCategoryScreen extends StatefulWidget {
  const LiveTvCategoryScreen({super.key});

  @override
  State<LiveTvCategoryScreen> createState() => _LiveTvCategoryScreenState();
}

class _LiveTvCategoryScreenState extends State<LiveTvCategoryScreen> with Utility {
  XFile? _selectedImage;

  Future<void> _pickImage(void Function(void Function()) setState) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextWidget(text: "LiveTv Category", fontSize: 15, fontWeight: FontWeight.w600),
              heightBox15(),
              Row(
                children: [
                  Expanded(
                    child: TextFormFieldWidget(
                      isSuffixIconShow: true,
                      suffixIcon: const Icon(Icons.search, color: AppColors.blackColor),
                    ),
                  ),
                  widthBox10(),
                  InkWell(
                    onTap: () {
                      _addUpdateLiveTvCategoryPopUp();
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
              BlocListener<UpdateLiveCategoryCubit, UpdateLiveCategoryState>(
                listener: (context, state) {
                  if (state is UpdateLiveCategoryErrorState) {
                    showMessage(context, state.error);
                    return;
                  }

                  if (state is UpdateLiveCategoryLoadedState) {
                    showMessage(context, "LiveTv category Update successfully.");
                    context.read<GetLiveCategoryCubit>().getAllLiveCategory();
                  }
                },
                child: BlocListener<DeleteLiveCategoryCubit, DeleteLiveCategoryState>(
                  listener: (context, state) {
                    if (state is DeleteLiveCategoryErrorState) {
                      showMessage(context, state.error);
                      return;
                    }

                    if (state is DeleteLiveCategoryLoadedState) {
                      showMessage(context, "Delete Successfully");
                      context.read<GetLiveCategoryCubit>().getAllLiveCategory();
                      Navigator.pop(context);
                    }
                  },
                  child: BlocBuilder<GetLiveCategoryCubit, GetLiveCategoryState>(
                    builder: (context, state) {
                      if (state is GetLiveCategoryLoadingState) {
                        return const Center(child: CustomCircularProgressIndicator());
                      }

                      if (state is GetLiveCategoryErrorState) {
                        return const Center(child: CustomErrorWidget());
                      }
                      if (state is GetLiveCategoryLoadedState) {
                        return state.model.data?.categories?.isEmpty ?? true
                            ? const CustomEmptyWidget()
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var data = state.model.data?.categories?[index];
                                  return Card(
                                    color: AppColors.whiteColor,
                                    surfaceTintColor: AppColors.whiteColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Title & Subtitle Section
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextWidget(
                                                  text: data?.name ?? "",
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                const SizedBox(height: 4),
                                                const TextWidget(text: "23", color: AppColors.greyColor),
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
                                                      _addUpdateLiveTvCategoryPopUp(
                                                        id: data?.id,
                                                        name: data?.name,
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
                                                              context
                                                                  .read<DeleteLiveCategoryCubit>()
                                                                  .deleteLiveCategory(data?.id ?? "");
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: svgAsset(assetName: AppImages.deleteSvg),
                                                  ),
                                                ],
                                              ),
                                              heightBox10(),
                                              Switch(
                                                activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                thumbColor: const WidgetStatePropertyAll(
                                                  Color.fromRGBO(65, 160, 255, 1),
                                                ),
                                                value: data?.status ?? false,
                                                onChanged: (value) {
                                                  context.read<UpdateLiveCategoryCubit>().updateLiveCategory(
                                                    id: data?.id ?? "",
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
                                itemCount: state.model.data?.categories?.length,
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

  _addUpdateLiveTvCategoryPopUp({String? id, String? name, bool? status}) {
    final TextEditingController nameController = TextEditingController(text: name ?? "");
    bool isActive = status ?? false;
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
                          TextWidget(
                            text: id != null ? "Update LiveTv Category" : "Add LiveTv Category",
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
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
                              onTap: () {
                                _pickImage(setState);
                              },
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
                      heightBox15(),
                      const TextWidget(text: "LiveTv Category Title", color: AppColors.blackColor),
                      heightBox10(),
                      TextFormFieldWidget(controller: nameController),
                      heightBox15(),
                      const TextWidget(text: "Status", color: AppColors.blackColor),
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
                      BlocConsumer<CreateLiveCategoryCubit, CreateLiveCategoryState>(
                        listener: (context, state) {
                          if (state is CreateLiveCategoryErrorState) {
                            showMessage(context, state.error);
                            return;
                          }

                          if (state is CreateLiveCategoryLoadedState) {
                            Navigator.pop(context);
                            showMessage(context, "LiveTv category created successfully.");
                            context.read<GetLiveCategoryCubit>().getAllLiveCategory();
                          }
                        },
                        builder: (context, postState) {
                          return BlocConsumer<UpdateLiveCategoryCubit, UpdateLiveCategoryState>(
                            listener: (context, postState) {
                              if (postState is UpdateLiveCategoryErrorState) {
                                showMessage(context, postState.error);
                                return;
                              }

                              if (postState is UpdateLiveCategoryLoadedState) {
                                Navigator.pop(context);
                                showMessage(context, "LiveTv category Update successfully.");
                                context.read<GetLiveCategoryCubit>();
                              }
                            },
                            builder: (context, state) {
                              return CustomOutlinedButton(
                                inProgress:
                                    (postState is CreateLiveCategoryLoadingState ||
                                    state is UpdateLiveCategoryLoadingState),
                                onPressed: () {
                                  if (nameController.text.isEmpty) {
                                    showMessage(context, "Add title");
                                    return;
                                  }
                                  if (id != null) {
                                    context.read<UpdateLiveCategoryCubit>().updateLiveCategory(
                                      id: id,
                                      name: nameController.text,
                                      status: isActive,
                                      coverImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                    );

                                    return;
                                  }

                                  context.read<CreateLiveCategoryCubit>().createLiveCategory(
                                    nameController.text,
                                    isActive,
                                    coverImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                  );
                                },
                                buttonText: id != null ? 'Save LiveTv Category' : 'Add LiveTv Category',
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
