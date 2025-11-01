import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite_admin/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elite_admin/bloc/movie/genre/delete_genre/delete_genre_cubit.dart';
import 'package:elite_admin/bloc/movie/genre/get_all_genre/get_all_genre_cubit.dart';
import 'package:elite_admin/bloc/movie/genre/post_genre/post_genre_cubit.dart';
import 'package:elite_admin/bloc/movie/genre/update_genre/update_genre_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/constant/image_picker_utils.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_empty_widget.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/delete_dialog.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> with Utility {
  XFile? _selectedImage;
  Future<void> _pickImage(StateSetter setState) async {
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

  final searchController = TextEditingController();

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
              const TextWidget(text: "Genre", fontSize: 15, fontWeight: FontWeight.w600),
              heightBox15(),
              Row(
                children: [
                  Expanded(
                    child: TextFormFieldWidget(
                      controller: searchController,
                      isSuffixIconShow: true,
                      onChanged: (p0) {
                        context.read<GetAllGenreCubit>().getGenre(name: p0);
                      },
                      suffixIcon: const Icon(Icons.search, color: AppColors.blackColor),
                    ),
                  ),
                  widthBox10(),
                  InkWell(
                    onTap: () {
                      context.read<GetAllGenreCubit>().getGenre();
                      _addUpdateGenrePopUp();
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
              BlocListener<UpdateGenreCubit, UpdateGenreState>(
                listener: (context, state) {
                  if (state is UpdateGenreErrorState) {
                    showMessage(context, state.error);
                    return;
                  }

                  if (state is UpdateGenreLoadedState) {
                    showMessage(context, "Update Genre Sucessfully");
                    context.read<GetAllGenreCubit>().getGenre();
                  }
                },
                child: BlocListener<DeleteGenreCubit, DeleteGenreState>(
                  listener: (context, state) {
                    if (state is DeleteGenreErrorState) {
                      showMessage(context, state.error);
                      return;
                    }

                    if (state is DeleteGenreLoadedState) {
                      showMessage(context, "Delete Sucessfully");
                      Navigator.pop(context);
                      context.read<GetAllGenreCubit>().getGenre();
                    }
                  },
                  child: BlocBuilder<GetAllGenreCubit, GetAllGenreState>(
                    builder: (context, state) {
                      if (state is GetAllGenreLoadingState) {
                        return const Center(child: CustomCircularProgressIndicator());
                      }

                      if (state is GetAllGenreErrorState) {
                        return Center(
                          child: InkWell(
                            onTap: () {
                              context.read<GetAllGenreCubit>().getGenre();
                            },
                            child: CustomErrorWidget(),
                          ),
                        );
                      }

                      if (state is GetAllGenreLaodedState) {
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
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: CachedNetworkImage(
                                              height: 100,
                                              width: 120,
                                              imageUrl: "${AppUrls.baseUrl}/${data?.coverImg}",
                                              fit: BoxFit.fill,
                                              errorWidget: (context, url, error) {
                                                return const Center(child: TextWidget(text: "No Img 😒"));
                                              },
                                            ),
                                          ),
                                          widthBox10(),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                heightBox10(),
                                                TextWidget(
                                                  text: "${data?.name}",
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                const SizedBox(height: 4),
                                                const TextWidget(text: "09", color: AppColors.greyColor),
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
                                                      _addUpdateGenrePopUp(
                                                        id: data?.id,
                                                        status: data?.status,
                                                        title: data?.name,
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
                                                              context.read<DeleteGenreCubit>().deleteGenre(
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
                                                  context.read<UpdateGenreCubit>().updateGenre(
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

  _addUpdateGenrePopUp({String? id, String? title, bool? status}) {
    final TextEditingController titleController = TextEditingController(text: title ?? "");
    bool isActive = status ?? false;

    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextWidget(text: "Genre", fontWeight: FontWeight.w700, fontSize: 15),
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
                                _pickImage(setState); // Pass setState here
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
                                          SvgPicture.asset("asset/svg/profile-circle.svg"),
                                          heightBox10(),
                                          const TextWidget(text: "Select a Cover picture"),
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
                      const TextWidget(text: "Genre Title", color: AppColors.blackColor),
                      heightBox10(),
                      TextFormFieldWidget(controller: titleController),
                      heightBox10(),
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
                      BlocConsumer<UpdateGenreCubit, UpdateGenreState>(
                        listener: (context, state) {
                          if (state is UpdateGenreErrorState) {
                            showMessage(context, state.error);
                            return;
                          }

                          if (state is UpdateGenreLoadedState) {
                            showMessage(context, "Update Sucessfully");
                            context.read<GetAllGenreCubit>().getGenre();
                            Navigator.pop(context);
                          }
                        },
                        builder: (context, updateState) {
                          return BlocConsumer<PostGenreCubit, PostGenreState>(
                            listener: (context, state) {
                              if (state is PostGenreErrorState) {
                                showMessage(context, state.error);
                                return;
                              }

                              if (state is PostGenreLaodedState) {
                                showMessage(context, "Post Genre Successfully");
                                context.read<GetAllGenreCubit>().getGenre();
                                Navigator.pop(context);
                              }
                            },
                            builder: (context, state) {
                              return CustomOutlinedButton(
                                inProgress: (updateState is UpdateGenreLoadingState || state is PostGenreLoadingState),
                                onPressed: () {
                                  if (id != null) {
                                    context.read<UpdateGenreCubit>().updateGenre(
                                      id: id,
                                      name: titleController.text,
                                      status: isActive,
                                      coverImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                    );
                                    return;
                                  }

                                  context.read<PostGenreCubit>().postGenre(
                                    name: titleController.text,
                                    status: isActive,
                                    coverImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                  );
                                },
                                buttonText: id != null ? 'Save Genre' : 'Add Genre',
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    ).then((e) {
      setState(() {
        _selectedImage = null;
      });
    });
  }
}
