import 'dart:io';

import 'package:elite_admin/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elite_admin/bloc/movie/category/delete_category/delete_category_cubit.dart';
import 'package:elite_admin/bloc/movie/category/get_all_category/get_all_category_cubit.dart';
import 'package:elite_admin/bloc/movie/category/post_category/post_category_cubit.dart';
import 'package:elite_admin/bloc/movie/category/update_category/update_category_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/constant/image_picker_utils.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_empty_widget.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/custom_pagination.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/delete_dialog.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class MovieCategoryScreen extends StatefulWidget {
  const MovieCategoryScreen({super.key});

  @override
  State<MovieCategoryScreen> createState() => _MovieCategoryScreenState();
}

class _MovieCategoryScreenState extends State<MovieCategoryScreen> with Utility {
  final searchController = TextEditingController();
  int currentPage = 1;
  XFile? _selectedImage;
  Future<void> _pickImage(setState) async {
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
              const TextWidget(text: "Movie Category", fontSize: 15, fontWeight: FontWeight.w600),
              heightBox15(),
              Row(
                children: [
                  Expanded(
                    child: TextFormFieldWidget(
                      controller: searchController,
                      onChanged: (p0) {
                        context.read<GetAllMovieCategoryCubit>().getAllMovieCategory(name: p0);
                      },
                      isSuffixIconShow: true,
                      suffixIcon: const Icon(Icons.search, color: AppColors.blackColor),
                    ),
                  ),
                  widthBox10(),
                  InkWell(
                    onTap: () {
                      _addUpdateMovieCategoryPopUp();
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
              BlocListener<UpdateCategoryCubit, UpdateCategoryState>(
                listener: (context, state) {
                  if (state is UpdateCategoryErrorState) {
                    showMessage(context, state.error);
                    return;
                  }

                  if (state is UpdateCategoryLoadedState) {
                    showMessage(context, "Movie category Update successfully.");
                    context.read<GetAllMovieCategoryCubit>().getAllMovieCategory();
                  }
                },
                child: BlocListener<DeleteCategoryCubit, DeleteCategoryState>(
                  listener: (context, state) {
                    if (state is DeleteCategoryErrorState) {
                      showMessage(context, state.error);
                      return;
                    }

                    if (state is DeleteCategoryLoadedState) {
                      showMessage(context, "Delete Successfully");
                      context.read<GetAllMovieCategoryCubit>().getAllMovieCategory();
                      Navigator.pop(context);
                    }
                  },
                  child: BlocBuilder<GetAllMovieCategoryCubit, GetAllCategoryState>(
                    builder: (context, state) {
                      if (state is GetAllCategoryLoadingState) {
                        return const Center(child: CustomCircularProgressIndicator());
                      }

                      if (state is GetAllCategoryErrorState) {
                        return const Center(child: CustomErrorWidget());
                      }
                      if (state is GetAllCategoryLoadedState) {
                        return state.model.categories?.isEmpty ?? true
                            ? const Center(child: CustomEmptyWidget())
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var data = state.model.categories?[index];
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
                                                      _addUpdateMovieCategoryPopUp(
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
                                                              context.read<DeleteCategoryCubit>().deleteMovieCategory(
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
                                              heightBox10(),
                                              Switch(
                                                activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                thumbColor: const WidgetStatePropertyAll(
                                                  Color.fromRGBO(65, 160, 255, 1),
                                                ),
                                                value: data?.status ?? false,
                                                onChanged: (value) {
                                                  context.read<UpdateCategoryCubit>().updateCategory(
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
                                itemCount: state.model.categories?.length,
                              );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
              heightBox15(),
              BlocBuilder<GetAllMovieCategoryCubit, GetAllCategoryState>(
                builder: (context, state) {
                  if (state is GetAllCategoryLoadedState) {
                    return CustomPagination(
                      currentPage: currentPage,
                      totalPages: state.model.totalPages ?? 0,
                      onPageChanged: (e) {
                        setState(() {
                          currentPage = e;
                        });
                        context.read<GetAllMovieCategoryCubit>().getAllMovieCategory(page: currentPage);
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addUpdateMovieCategoryPopUp({String? id, String? name, bool? status}) {
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
                            text: id != null ? "Update Movie Category" : "Add Movie Category",
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
                      heightBox15(),
                      const TextWidget(text: "Movie Category Title", color: AppColors.blackColor),
                      heightBox10(),
                      TextFormFieldWidget(controller: nameController),
                      heightBox15(),
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
                      BlocConsumer<PostCategoryCubit, PostCategoryState>(
                        listener: (context, state) {
                          if (state is PostCategoryErrorState) {
                            showMessage(context, state.error);
                            return;
                          }

                          if (state is PostCategoryLoadedState) {
                            Navigator.pop(context);
                            showMessage(context, "Movie category created successfully.");
                            context.read<GetAllMovieCategoryCubit>().getAllMovieCategory();
                          }
                        },
                        builder: (context, postState) {
                          return BlocConsumer<UpdateCategoryCubit, UpdateCategoryState>(
                            listener: (context, postState) {
                              if (postState is UpdateCategoryErrorState) {
                                showMessage(context, postState.error);
                                return;
                              }

                              if (postState is UpdateCategoryLoadedState) {
                                Navigator.pop(context);
                                showMessage(context, "Movie category Update successfully.");
                                context.read<GetAllMovieCategoryCubit>().getAllMovieCategory();
                              }
                            },
                            builder: (context, state) {
                              return CustomOutlinedButton(
                                inProgress:
                                    (postState is PostCategoryLoadingState || state is UpdateCategoryLoadingState),
                                onPressed: () {
                                  if (nameController.text.isEmpty) {
                                    showMessage(context, "Add title");
                                    return;
                                  }
                                  if (id != null) {
                                    context.read<UpdateCategoryCubit>().updateCategory(
                                      id: id,
                                      name: nameController.text,
                                      status: isActive,
                                      img: _selectedImage != null ? File(_selectedImage!.path) : null,
                                    );

                                    return;
                                  }

                                  context.read<PostCategoryCubit>().postCategory(
                                    nameController.text,
                                    _selectedImage != null ? File(_selectedImage!.path) : null,
                                    isActive,
                                  );
                                },
                                buttonText: id != null ? 'Save Movie Category' : 'Add Movie Category',
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
