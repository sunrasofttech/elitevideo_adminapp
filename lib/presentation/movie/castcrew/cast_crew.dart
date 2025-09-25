import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elite_admin/bloc/movie/cast_crew/create_castcrew/create_castcrew_cubit.dart';
import 'package:elite_admin/bloc/movie/cast_crew/delete_cast_crew/delete_cast_crew_cubit.dart';
import 'package:elite_admin/bloc/movie/cast_crew/get_all_castcrew/get_all_castcrew_cubit.dart';
import 'package:elite_admin/bloc/movie/cast_crew/update_cast_crew/update_cast_crew_cubit.dart';
import 'package:elite_admin/bloc/movie/upload_movie/get_all_movie/get_all_movie_cubit.dart';
import 'package:elite_admin/bloc/movie/upload_movie/get_all_movie/get_all_movie_model.dart';
import 'package:elite_admin/constant/color.dart';
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

import '../../../constant/image.dart';

class CastCrewScreen extends StatefulWidget {
  const CastCrewScreen({super.key});

  @override
  State<CastCrewScreen> createState() => _CastCrewScreenState();
}

class _CastCrewScreenState extends State<CastCrewScreen> with Utility {
  ValueNotifier<String?> selectedMovie = ValueNotifier<String?>(null);
  XFile? _selectedImage;
  Future<void> _pickImage(StateSetter setState) async {
    final pickedFile = await ImagePickerUtil.pickImageFromGallery(
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  int currentPage = 1;

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
                text: "Cast Crew",
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              heightBox15(),
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<GetAllMovieCubit, GetAllMovieState>(
                      builder: (context, state) {
                        if (state is GetAllMovieLoadingState) {
                          return const Center(
                            child: CustomCircularProgressIndicator(),
                          );
                        }

                        if (state is GetAllMovieLaodedState) {
                          final marketNames =
                              state.model.data?.movies?.map((datum) => datum.movieName ?? '').toList() ?? [];
                          return ValueListenableBuilder<String?>(
                            valueListenable: selectedMovie,
                            builder: (context, value, child) {
                              final marketData = state.model.data?.movies ?? [];
                              return DropdownSearch<String>(
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  menuProps: const MenuProps(
                                    backgroundColor: AppColors.whiteColor,
                                  ),
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      fillColor: AppColors.blackColor,
                                      hintText: "Search Movie Type",
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.greyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    ),
                                  ),
                                  itemBuilder: (context, item, isDisabled, isSelected) {
                                    return SizedBox(
                                      height: 40,
                                      child: Row(
                                        children: [
                                          if (isSelected) Icon(Icons.check, color: Theme.of(context).primaryColor),
                                          widthBox10(),
                                          Expanded(
                                            child: Text(
                                              item,
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                items: (filter, loadProps) {
                                  return marketNames;
                                },
                                decoratorProps: const DropDownDecoratorProps(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.greyColor),
                                    ),
                                    hintText: "Movie Type",
                                    hintStyle: TextStyle(
                                      fontSize: 11,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.greyColor),
                                    ),
                                  ),
                                ),
                                selectedItem: marketData
                                    .firstWhere(
                                      (datum) => datum.id == value,
                                      orElse: () => Movie(),
                                    )
                                    .movieName,
                                onChanged: (String? newValue) {
                                  final selectedItem =
                                      state.model.data?.movies?.firstWhere((datum) => datum.movieName == newValue);
                                  selectedMovie.value = selectedItem?.id;
                                  log("Selected Market ID: ${selectedMovie.value}  $newValue");
                                  context.read<GetAllCastcrewCubit>().getAllCastCrew(movieId: selectedMovie.value);
                                },
                              );
                            },
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ),
                  widthBox10(),
                  InkWell(
                    onTap: () {
                      _addUpdatecastCrewPopUp();
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
              BlocListener<UpdateCastCrewCubit, UpdateCastCrewState>(
                listener: (context, state) {
                  if (state is UpdateCastCrewErrorState) {
                    Fluttertoast.showToast(msg: state.error);
                    return;
                  }

                  if (state is UpdateCastCrewLoadedState) {
                    Fluttertoast.showToast(msg: "Update castCrew Sucessfully");
                    context.read<GetAllCastcrewCubit>().getAllCastCrew(page: currentPage);
                  }
                },
                child: BlocListener<DeleteCastCrewCubit, DeleteCastCrewState>(
                  listener: (context, state) {
                    if (state is DeleteCastCrewErrorState) {
                      Fluttertoast.showToast(msg: state.error);
                      return;
                    }

                    if (state is DeleteCastCrewLaodedState) {
                      Fluttertoast.showToast(msg: "Delete Sucessfully");
                      Navigator.pop(context);
                      context.read<GetAllCastcrewCubit>().getAllCastCrew(page: currentPage);
                    }
                  },
                  child: BlocBuilder<GetAllCastcrewCubit, GetAllCastcrewState>(
                    builder: (context, state) {
                      if (state is GetAllCastcrewLoadingState) {
                        return const Center(
                          child: CustomCircularProgressIndicator(),
                        );
                      }

                      if (state is GetAllCastcrewErrorState) {
                        return InkWell(
                          onTap: () {
                            context.read<GetAllCastcrewCubit>().getAllCastCrew();
                          },
                          child: const Center(
                            child: CustomErrorWidget(),
                          ),
                        );
                      }

                      if (state is GetAllCastcrewLoadedState) {
                        return state.model.data?.isEmpty ?? false
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
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: CachedNetworkImage(
                                              height: 100,
                                              width: 120,
                                              imageUrl: "${AppUrls.baseUrl}/${data?.profileImg}",
                                              fit: BoxFit.fill,
                                              errorWidget: (context, url, error) {
                                                return const Center(
                                                  child: TextWidget(
                                                    text: "No Img 😒",
                                                  ),
                                                );
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
                                                TextWidget(
                                                  text: "${data?.role}",
                                                  color: AppColors.greyColor,
                                                ),
                                                const SizedBox(height: 4),
                                                TextWidget(
                                                  text: "Movie Name : ${data?.movie?.movieName}",
                                                  color: AppColors.blackColor,
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
                                                      _addUpdatecastCrewPopUp(
                                                        id: data?.id,
                                                        description: data?.description,
                                                        name: data?.name,
                                                        role: data?.role,
                                                        movieId: data?.movieId,
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
                                                                  .read<DeleteCastCrewCubit>()
                                                                  .deleteCastCrew(data?.id ?? "");
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: svgAsset(
                                                      assetName: AppImages.deleteSvg,
                                                    ),
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
              ),
              heightBox15(),
              BlocBuilder<GetAllCastcrewCubit, GetAllCastcrewState>(
                builder: (context, state) {
                  if (state is GetAllCastcrewLoadedState) {
                    return CustomPagination(
                        currentPage: currentPage,
                        totalPages: state.model.pagination?.totalPages ?? 0,
                        onPageChanged: (e) {
                          setState(() {
                            currentPage = e;
                          });
                          context.read<GetAllMovieCubit>().getAllMovie(
                                page: currentPage,
                              );
                        });
                  }
                  return const SizedBox();
                },
              ),
              heightBox15(),
            ],
          ),
        ),
      ),
    );
  }

  _addUpdatecastCrewPopUp({
    String? id,
    String? name,
    String? description,
    String? role,
    String? movieId,
  }) {
    final TextEditingController nameController = TextEditingController(text: name ?? "");
    final TextEditingController descriptionController = TextEditingController(text: description ?? "");
    final TextEditingController roleContoller = TextEditingController(text: role ?? "");
    if (movieId != null) selectedMovie.value = movieId;
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: StatefulBuilder(builder: (context, setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TextWidget(
                          text: "castCrew",
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
                            onTap: () {
                              _pickImage(setState);
                            },
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
                    const TextWidget(
                      text: "Name *",
                      color: AppColors.blackColor,
                    ),
                    heightBox10(),
                    TextFormFieldWidget(
                      controller: nameController,
                    ),
                    heightBox15(),
                    const TextWidget(
                      text: "Description *",
                      color: AppColors.blackColor,
                    ),
                    heightBox10(),
                    TextFormFieldWidget(
                      controller: descriptionController,
                    ),
                    heightBox15(),
                    const TextWidget(
                      text: "Role *",
                      color: AppColors.blackColor,
                    ),
                    heightBox10(),
                    TextFormFieldWidget(
                      controller: roleContoller,
                    ),
                    heightBox10(),
                    const TextWidget(
                      text: "Select Movie *",
                      color: AppColors.blackColor,
                    ),
                    heightBox10(),
                    BlocBuilder<GetAllMovieCubit, GetAllMovieState>(
                      builder: (context, state) {
                        if (state is GetAllMovieLoadingState) {
                          return const Center(
                            child: CustomCircularProgressIndicator(),
                          );
                        }

                        if (state is GetAllMovieLaodedState) {
                          final marketNames =
                              state.model.data?.movies?.map((datum) => datum.movieName ?? '').toList() ?? [];
                          return ValueListenableBuilder<String?>(
                            valueListenable: selectedMovie,
                            builder: (context, value, child) {
                              final marketData = state.model.data?.movies ?? [];
                              return DropdownSearch<String>(
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  menuProps: const MenuProps(
                                    backgroundColor: AppColors.whiteColor,
                                  ),
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      fillColor: AppColors.blackColor,
                                      hintText: "Search Movie Type",
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.greyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    ),
                                  ),
                                  itemBuilder: (context, item, isDisabled, isSelected) {
                                    return SizedBox(
                                      height: 40,
                                      child: Row(
                                        children: [
                                          if (isSelected) Icon(Icons.check, color: Theme.of(context).primaryColor),
                                          widthBox10(),
                                          Expanded(
                                            child: Text(
                                              item,
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                items: (filter, loadProps) {
                                  return marketNames;
                                },
                                decoratorProps: const DropDownDecoratorProps(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.greyColor),
                                    ),
                                    hintText: "Movie Type",
                                    hintStyle: TextStyle(
                                      fontSize: 11,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.greyColor),
                                    ),
                                  ),
                                ),
                                selectedItem: marketData
                                    .firstWhere(
                                      (datum) => datum.id == value,
                                      orElse: () => Movie(),
                                    )
                                    .movieName,
                                onChanged: (String? newValue) {
                                  final selectedItem =
                                      state.model.data?.movies?.firstWhere((datum) => datum.movieName == newValue);
                                  selectedMovie.value = selectedItem?.id;
                                  log("Selected Market ID: ${selectedMovie.value}  $newValue");
                                },
                              );
                            },
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                    heightBox15(),
                    BlocConsumer<UpdateCastCrewCubit, UpdateCastCrewState>(
                      listener: (context, state) {
                        if (state is UpdateCastCrewErrorState) {
                          Fluttertoast.showToast(msg: state.error);
                          return;
                        }

                        if (state is UpdateCastCrewLoadedState) {
                          Fluttertoast.showToast(msg: "Update Sucessfully");
                          context.read<GetAllCastcrewCubit>().getAllCastCrew(page: currentPage);
                          Navigator.pop(context);
                        }
                      },
                      builder: (context, updateState) {
                        return BlocConsumer<CreateCastcrewCubit, CreateCastcrewState>(
                          listener: (context, state) {
                            if (state is CreateCastcrewErrorState) {
                              Fluttertoast.showToast(msg: state.error);
                              return;
                            }

                            if (state is CreateCastcrewLoadedState) {
                              Fluttertoast.showToast(msg: "Post castCrew Successfully");
                              context.read<GetAllCastcrewCubit>().getAllCastCrew();
                              Navigator.pop(context);
                            }
                          },
                          builder: (context, state) {
                            return CustomOutlinedButton(
                              inProgress:
                                  (updateState is UpdateCastCrewLoadingState || state is CreateCastcrewLoadingState),
                              onPressed: () {
                                if (id != null) {
                                  context.read<UpdateCastCrewCubit>().updateCastCrew(
                                        id: id,
                                        name: nameController.text,
                                        profileImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                        description: descriptionController.text,
                                        movieId: selectedMovie.value,
                                        role: roleContoller.text,
                                      );
                                  return;
                                }

                                context.read<CreateCastcrewCubit>().createCastCrew(
                                      name: nameController.text,
                                      description: descriptionController.text,
                                      movieId: selectedMovie.value,
                                      profileImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                      role: roleContoller.text,
                                    );
                              },
                              buttonText: id != null ? 'Save castCrew' : 'Add castCrew',
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              }),
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
