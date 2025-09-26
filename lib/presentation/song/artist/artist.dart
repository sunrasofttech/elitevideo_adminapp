import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:elite_admin/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elite_admin/bloc/music/artist/delete_artist/delete_artist_cubit.dart';
import 'package:elite_admin/bloc/music/artist/get_artist/get_artist_cubit.dart';
import 'package:elite_admin/bloc/music/artist/post_artist/post_artist_cubit.dart';
import 'package:elite_admin/bloc/music/artist/update_artist/update_artist_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/constant/image_picker_utils.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_empty_widget.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({super.key});

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> with Utility {
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
              const TextWidget(text: "Music Artist", fontSize: 15, fontWeight: FontWeight.w600),
              heightBox15(),
              Row(
                children: [
                  // Expanded(
                  //     child: TextFormFieldWidget(
                  //   controller: searchController,
                  //   isSuffixIconShow: true,
                  //   onChanged: (p0) {
                  //     context.read<GetAllMusicCategoryCubit>().getAllMusic(
                  //           search: p0,
                  //         );
                  //   },
                  //   suffixIcon: const Icon(
                  //     Icons.search,
                  //     color: AppColors.blackColor,
                  //   ),
                  // )),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      _addUpdateMusicCategoryPopUp();
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
              BlocListener<DeleteArtistCubit, DeleteArtistState>(
                listener: (context, state) {
                  if (state is DeleteArtistLoadedState) {
                   showMessage(context, "Delete Successfully");
                    context.read<GetArtistCubit>().getAllArtist();
                  }

                  if (state is DeleteArtistErrorState) {
                   showMessage(context, state.error);
                    return;
                  }
                },
                child: BlocBuilder<GetArtistCubit, GetArtistState>(
                  builder: (context, state) {
                    if (state is GetArtistLoadingState) {
                      return const Center(child: CustomCircularProgressIndicator());
                    }

                    if (state is GetArtistErrorState) {
                      return const CustomErrorWidget();
                    }

                    if (state is GetArtistLoadedState) {
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
                                          imageUrl: "${AppUrls.baseUrl}/${data?.profileImg}",
                                          height: 100,
                                          width: 100,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              heightBox15(),
                                              TextWidget(
                                                text: "${data?.artistName}",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    _addUpdateMusicCategoryPopUp(id: data?.id, name: data?.artistName);
                                                  },
                                                  child: svgAsset(assetName: AppImages.editSvg),
                                                ),
                                                widthBox5(),
                                                InkWell(
                                                  onTap: () {
                                                    context.read<DeleteArtistCubit>().deleteArtistCategory(
                                                      data?.id ?? "",
                                                    );
                                                  },
                                                  child: svgAsset(assetName: AppImages.deleteSvg),
                                                ),
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
              // heightBox15(),
              // BlocBuilder<GetAllMusicCategoryCubit, GetAllMusicCategoryState>(
              //   builder: (context, state) {
              //     if (state is GetAllMusicCategoryLoadedState) {
              //       return CustomPagination(
              //           currentPage: currentPage,
              //           totalPages: state.model.pagination?.totalPages ?? 0,
              //           onPageChanged: (e) {
              //             setState(() {
              //               currentPage = e;
              //             });
              //             context.read<GetAllMusicCategoryCubit>().getAllMusic(
              //                   page: currentPage,
              //                 );
              //           });
              //     }
              //     return const SizedBox();
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  _addUpdateMusicCategoryPopUp({String? id, String? name}) {
    final titleController = TextEditingController(text: name ?? "");
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
          child: StatefulBuilder(
            builder: (context, setState) {
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
                            text: id != null ? "Update Artist" : "Add Artist",
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
                      const TextWidget(text: "Artist Name", color: AppColors.blackColor),
                      heightBox10(),
                      TextFormFieldWidget(controller: titleController),
                      heightBox10(),
                      const TextWidget(text: "Artist Image", color: AppColors.blackColor),
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
                      heightBox20(),
                      BlocConsumer<UpdateArtistCubit, UpdateArtistState>(
                        listener: (context, state) {
                          if (state is UpdateArtistErrorState) {
                           showMessage(context, state.error);
                            return;
                          }
                          if (state is UpdateArtistLoadedState) {
                           showMessage(context, "Update Succesfully");
                            Navigator.pop(context);
                            context.read<GetArtistCubit>().getAllArtist();
                          }
                        },
                        builder: (context, state) {
                          return BlocConsumer<PostArtistCubit, PostArtistState>(
                            listener: (context, state) {
                              if (state is PostArtistLoadedState) {
                               showMessage(context, "Post Sucessfully");
                                Navigator.pop(context);
                                context.read<GetArtistCubit>().getAllArtist();
                              }
                            },
                            builder: (context, postState) {
                              return CustomOutlinedButton(
                                inProgress: (postState is PostArtistLoadingState || state is UpdateArtistLoadingState),
                                onPressed: () {
                                  if (id != null) {
                                    context.read<UpdateArtistCubit>().updateArtistCategory(
                                      artistName: titleController.text,
                                      id: id,
                                      coverImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                    );
                                    return;
                                  }
                                  context.read<PostArtistCubit>().postArtistCategory(
                                    titleController.text,
                                    coverImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                  );
                                },
                                buttonText: id != null ? 'Save Artist' : 'Add Artist',
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
