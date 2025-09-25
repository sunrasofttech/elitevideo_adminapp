import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elite_admin/bloc/web_series/castcrew/create_cast_crew/create_cast_crew_webseries_cubit.dart';
import 'package:elite_admin/bloc/web_series/castcrew/delete_webseries_castcrew/delete_webseries_castcrew_cubit.dart';
import 'package:elite_admin/bloc/web_series/castcrew/get_all_cast_crew/get_all_cast_crew_webseries_cubit.dart';
import 'package:elite_admin/bloc/web_series/castcrew/update_cast_crew_webseries/update_cast_crew_webseries_cubit.dart';
import 'package:elite_admin/bloc/web_series/series/get_all_series/get_all_Series_model.dart';
import 'package:elite_admin/bloc/web_series/series/get_all_series/get_all_series_cubit.dart';
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

class WebScreenCastCrewScreen extends StatefulWidget {
  const WebScreenCastCrewScreen({super.key});

  @override
  State<WebScreenCastCrewScreen> createState() => _CastCrewScreenState();
}

class _CastCrewScreenState extends State<WebScreenCastCrewScreen> with Utility {
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
                    child: BlocBuilder<GetAllSeriesCubit, GetAllSeriesState>(
                      builder: (context, state) {
                        if (state is GetAllSeriesLoadingState) {
                          return const Center(
                            child: CustomCircularProgressIndicator(),
                          );
                        }

                        if (state is GetAllSeriesLoadedState) {
                          final marketNames = state.model.data?.map((datum) => datum.seriesName ?? '').toList() ?? [];
                          return ValueListenableBuilder<String?>(
                            valueListenable: selectedMovie,
                            builder: (context, value, child) {
                              final marketData = state.model.data ?? [];
                              return DropdownSearch<String>(
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  menuProps: const MenuProps(
                                    backgroundColor: AppColors.whiteColor,
                                  ),
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      fillColor: AppColors.blackColor,
                                      hintText: "Search Series Type",
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
                                    hintText: "Series Type",
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
                                      orElse: () => Datum(),
                                    )
                                    .seriesName,
                                onChanged: (String? newValue) {
                                  final selectedItem =
                                      state.model.data?.firstWhere((datum) => datum.seriesName == newValue);
                                  selectedMovie.value = selectedItem?.id;
                                  log("Selected Market ID: ${selectedMovie.value}  $newValue");
                                  context
                                      .read<GetAllCastCrewWebseriesCubit>()
                                      .getAllCastCrew(movieId: selectedMovie.value);
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
              BlocListener<UpdateCastCrewWebseriesCubit, UpdateCastCrewWebseriesState>(
                listener: (context, state) {
                  if (state is UpdateCastCrewWebseriesErrorState) {
                    Fluttertoast.showToast(msg: state.error);
                    return;
                  }

                  if (state is UpdateCastCrewWebseriesLoadedState) {
                    Fluttertoast.showToast(msg: "Update castCrew Sucessfully");
                    context.read<GetAllCastCrewWebseriesCubit>().getAllCastCrew(page: currentPage);
                  }
                },
                child: BlocListener<DeleteWebseriesCastcrewCubit, DeleteWebseriesCastcrewState>(
                  listener: (context, state) {
                    if (state is DeleteWebseriesCastcrewErrorState) {
                      Fluttertoast.showToast(msg: state.error);
                      return;
                    }

                    if (state is DeleteWebseriesCastcrewLoadedState) {
                      Fluttertoast.showToast(msg: "Delete Sucessfully");
                      context.read<GetAllCastCrewWebseriesCubit>().getAllCastCrew(page: 1);
                    }
                  },
                  child: BlocBuilder<GetAllCastCrewWebseriesCubit, GetAllCastCrewWebseriesState>(
                    builder: (context, state) {
                      if (state is GetAllCastCrewWebseriesLoadingState) {
                        return const Center(
                          child: CustomCircularProgressIndicator(),
                        );
                      }

                      if (state is GetAllCastCrewWebseriesErrorState) {
                        return const Center(
                          child: CustomErrorWidget(),
                        );
                      }

                      if (state is GetAllCastCrewWebseriesLoadedState) {
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
                                              imageUrl: "${data?.profileImg}",
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
                                                  text: "Series Name : ${data?.series?.seriesName}",
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
                                                        movieId: data?.series?.id,
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
                                                                  .read<DeleteWebseriesCastcrewCubit>()
                                                                  .deleteCastCrew(data?.id ?? "");
                                                              Navigator.pop(context);
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
              BlocBuilder<GetAllCastCrewWebseriesCubit, GetAllCastCrewWebseriesState>(
                builder: (context, state) {
                  if (state is GetAllCastCrewWebseriesLoadedState) {
                    return CustomPagination(
                        currentPage: currentPage,
                        totalPages: state.model.pagination?.totalPages ?? 0,
                        onPageChanged: (e) {
                          setState(() {
                            currentPage = e;
                          });
                          context.read<GetAllCastCrewWebseriesCubit>().getAllCastCrew(
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
                    BlocBuilder<GetAllSeriesCubit, GetAllSeriesState>(
                      builder: (context, state) {
                        if (state is GetAllSeriesLoadingState) {
                          return const Center(
                            child: CustomCircularProgressIndicator(),
                          );
                        }

                        if (state is GetAllSeriesLoadedState) {
                          final marketNames = state.model.data?.map((datum) => datum.seriesName ?? '').toList() ?? [];
                          return ValueListenableBuilder<String?>(
                            valueListenable: selectedMovie,
                            builder: (context, value, child) {
                              final marketData = state.model.data ?? [];
                              return DropdownSearch<String>(
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  menuProps: const MenuProps(
                                    backgroundColor: AppColors.whiteColor,
                                  ),
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      fillColor: AppColors.blackColor,
                                      hintText: "Search Series Type",
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
                                    hintText: "Series Type",
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
                                      orElse: () => Datum(),
                                    )
                                    .seriesName,
                                onChanged: (String? newValue) {
                                  final selectedItem =
                                      state.model.data?.firstWhere((datum) => datum.seriesName == newValue);
                                  selectedMovie.value = selectedItem?.id;
                                  log("Selected Market ID: ${selectedMovie.value}  $newValue");
                                  context
                                      .read<GetAllCastCrewWebseriesCubit>()
                                      .getAllCastCrew(movieId: selectedMovie.value);
                                },
                              );
                            },
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                    heightBox15(),
                    BlocConsumer<UpdateCastCrewWebseriesCubit, UpdateCastCrewWebseriesState>(
                      listener: (context, state) {
                        if (state is UpdateCastCrewWebseriesErrorState) {
                          Fluttertoast.showToast(msg: state.error);
                          return;
                        }

                        if (state is UpdateCastCrewWebseriesLoadedState) {
                          Fluttertoast.showToast(msg: "Update Sucessfully");
                          context.read<GetAllCastCrewWebseriesCubit>().getAllCastCrew(page: 1);
                          Navigator.pop(context);
                        }
                      },
                      builder: (context, updateState) {
                        return BlocConsumer<CreateCastCrewWebseriesCubit, CreateCastCrewWebseriesState>(
                          listener: (context, state) {
                            if (state is CreateCastCrewWebseriesErrorState) {
                              Fluttertoast.showToast(msg: state.error);
                              return;
                            }

                            if (state is CreateCastCrewWebseriesLoadedState) {
                              Fluttertoast.showToast(msg: "Post castCrew Successfully");
                              context.read<GetAllCastCrewWebseriesCubit>().getAllCastCrew(page: 1);
                              Navigator.pop(context);
                            }
                          },
                          builder: (context, state) {
                            return CustomOutlinedButton(
                              inProgress: (updateState is UpdateCastCrewWebseriesLoadingState ||
                                  state is CreateCastCrewWebseriesLoadingState),
                              onPressed: () {
                                if (id != null) {
                                  context.read<UpdateCastCrewWebseriesCubit>().updateCastCrew(
                                        id: id,
                                        name: nameController.text,
                                        profileImg: _selectedImage != null ? File(_selectedImage!.path) : null,
                                        description: descriptionController.text,
                                        movieId: selectedMovie.value,
                                        role: roleContoller.text,
                                      );
                                  return;
                                }

                                context.read<CreateCastCrewWebseriesCubit>().createCastCrew(
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
