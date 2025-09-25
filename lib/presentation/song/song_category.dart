import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elite_admin/bloc/music/category/delete_music_catrgory/delete_music_category_cubit.dart';
import 'package:elite_admin/bloc/music/category/get_all_music_category/get_all_music_category_cubit.dart';
import 'package:elite_admin/bloc/music/category/post_music_category/post_music_category_cubit.dart';
import 'package:elite_admin/bloc/music/category/update_music_category/update_music_category_cubit.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/constant/image_picker_utils.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_empty_widget.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/custom_pagination.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

import '../../constant/color.dart';

class SongCategoryScreen extends StatefulWidget {
  const SongCategoryScreen({super.key});

  @override
  State<SongCategoryScreen> createState() => _SongCategoryScreenState();
}

class _SongCategoryScreenState extends State<SongCategoryScreen> with Utility {
  final searchController = TextEditingController();
  int currentPage = 0;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
              const TextWidget(
                text: "Music Genre",
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              heightBox15(),
              Row(
                children: [
                  Expanded(
                      child: TextFormFieldWidget(
                    controller: searchController,
                    isSuffixIconShow: true,
                    onChanged: (p0) {
                      context.read<GetAllMusicCategoryCubit>().getAllMusic(
                            search: p0,
                          );
                    },
                    suffixIcon: const Icon(
                      Icons.search,
                      color: AppColors.blackColor,
                    ),
                  )),
                  widthBox10(),
                  InkWell(
                    onTap: () {
                      _addUpdateMusicCategoryPopUp();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        gradient: LinearGradient(
                          colors: AppColors.blueGradientList,
                        ),
                      ),
                      child: Row(
                        children: [
                          const TextWidget(
                            text: "Add",
                            color: AppColors.whiteColor,
                          ),
                          widthBox5(),
                          const Icon(
                            Icons.add_circle_rounded,
                            color: AppColors.whiteColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              heightBox20(),
              BlocListener<DeleteMusicCategoryCubit, DeleteMusicCategoryState>(
                listener: (context, state) {
                  if (state is DeleteMusicCategoryLoadedState) {
                    Fluttertoast.showToast(msg: "Delete Successfully");
                    context.read<GetAllMusicCategoryCubit>().getAllMusic();
                  }

                  if (state is DeleteMusicCategoryErrorState) {
                    Fluttertoast.showToast(msg: state.error);
                    return;
                  }
                },
                child: BlocBuilder<GetAllMusicCategoryCubit, GetAllMusicCategoryState>(
                  builder: (context, state) {
                    if (state is GetAllMusicCategoryLoadingState) {
                      return const Center(
                        child: CustomCircularProgressIndicator(),
                      );
                    }

                    if (state is GetAllMusicCategoryErrorState) {
                      return const CustomErrorWidget();
                    }

                    if (state is GetAllMusicCategoryLoadedState) {
                      return state.model.data?.isEmpty ?? true
                          ? const Center(
                              child: CustomEmptyWidget(),
                            )
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
                                        svgAsset(assetName: AppImages.imageSvg),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              heightBox15(),
                                              TextWidget(
                                                text: "${data?.name}",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              const SizedBox(height: 4),
                                              const TextWidget(
                                                text: "23",
                                                color: AppColors.greyColor,
                                              ),
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
                                                    _addUpdateMusicCategoryPopUp(
                                                      id: data?.id,
                                                      name: data?.name,
                                                    );
                                                  },
                                                  child: svgAsset(assetName: AppImages.editSvg),
                                                ),
                                                widthBox5(),
                                                InkWell(
                                                    onTap: () {
                                                      context
                                                          .read<DeleteMusicCategoryCubit>()
                                                          .deleteMusicCategory(data?.id ?? "");
                                                    },
                                                    child: svgAsset(assetName: AppImages.deleteSvg)),
                                              ],
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
              heightBox15(),
              BlocBuilder<GetAllMusicCategoryCubit, GetAllMusicCategoryState>(
                builder: (context, state) {
                  if (state is GetAllMusicCategoryLoadedState) {
                    return CustomPagination(
                        currentPage: currentPage,
                        totalPages: state.model.pagination?.totalPages ?? 0,
                        onPageChanged: (e) {
                          setState(() {
                            currentPage = e;
                          });
                          context.read<GetAllMusicCategoryCubit>().getAllMusic(
                                page: currentPage,
                              );
                        });
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

  _addUpdateMusicCategoryPopUp({String? id, String? name}) {
    final titleController = TextEditingController(text: name ?? "");
    XFile? _selectedImage;

    Future<void> _pickImage() async {
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
          child: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: id != null ? "Update Music Genre" : "Add Music Genre",
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
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    heightBox15(),
                    const TextWidget(
                      text: "Music Category Title",
                      color: AppColors.blackColor,
                    ),
                    heightBox10(),
                    TextFormFieldWidget(
                      controller: titleController,
                    ),
                    heightBox10(),
                    BlocConsumer<UpdateMusicCategoryCubit, UpdateMusicCategoryState>(
                      listener: (context, state) {
                        if (state is UpdateMusicCategoryErrorState) {
                          Fluttertoast.showToast(msg: state.error);
                          return;
                        }
                        if (state is UpdateMusicCategoryLoadedState) {
                          Fluttertoast.showToast(msg: "Update Succesfully");
                          Navigator.pop(context);
                          context.read<GetAllMusicCategoryCubit>().getAllMusic();
                        }
                      },
                      builder: (context, state) {
                        return BlocConsumer<PostMusicCategoryCubit, PostMusicCategoryState>(
                          listener: (context, state) {
                            if (state is PostMusicCategoryLoadedState) {
                              Fluttertoast.showToast(msg: "Post Sucessfully");
                              Navigator.pop(context);
                              context.read<GetAllMusicCategoryCubit>().getAllMusic();
                            }
                          },
                          builder: (context, postState) {
                            return CustomOutlinedButton(
                              inProgress: (postState is PostMusicCategoryLoadingState ||
                                  state is UpdateMusicCategoryLoadingState),
                              onPressed: () {
                                if (id != null) {
                                  context.read<UpdateMusicCategoryCubit>().updateMusic(
                                        titleController.text,
                                        id,
                                        _selectedImage != null ? File(_selectedImage!.path) : null,
                                      );
                                  return;
                                }
                                context.read<PostMusicCategoryCubit>().postMusicCategory(titleController.text);
                              },
                              buttonText: id != null ? 'Save Music Genre' : 'Add Music Genre',
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
