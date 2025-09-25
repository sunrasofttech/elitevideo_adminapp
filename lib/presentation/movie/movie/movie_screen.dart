import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:elite_admin/bloc/movie/category/get_all_category/get_all_category_cubit.dart';
import 'package:elite_admin/bloc/movie/language/get_all_language/get_all_language_cubit.dart';
import 'package:elite_admin/bloc/movie/upload_movie/delete_movie/delete_movie_cubit.dart';
import 'package:elite_admin/bloc/movie/upload_movie/get_all_movie/get_all_movie_cubit.dart';
import 'package:elite_admin/bloc/movie/upload_movie/update_movie/update_movie_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/presentation/movie/movie/add_update_movie.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_dropdown.dart';
import 'package:elite_admin/utils/widget/custom_empty_widget.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/custom_pagination.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/delete_dialog.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> with Utility {
  String? selectedLanguage;
  String? selectedLanguageId;
  String? selectedGenre;
  String? selectedGenreId;
  String? selectedCategory;
  String? selectedCategoryId;
  List<Map<String, dynamic>> castCrewList = [];
  double rating = 0;
  int currentPage = 1;
  final TextEditingController movieNameController = TextEditingController();
  final FocusNode movieNameFocusNode = FocusNode();
  List<String> selectedMovieIds = [];
  bool isSelectAll = false;

  @override
  void dispose() {
    movieNameFocusNode.dispose();
    movieNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<GetAllMovieCubit>().getAllMovie();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: ListView(
            children: [
              const TextWidget(
                text: "Manage Movies",
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              heightBox15(),
              Row(
                children: [
                  Expanded(
                      child: TextFormFieldWidget(
                    focusNode: movieNameFocusNode,
                    isSuffixIconShow: true,
                    hintText: "Search movie name ...",
                    controller: movieNameController,
                    onChanged: (p0) {
                      context.read<GetAllMovieCubit>().getAllMovie(
                            movieName: p0,
                          );
                    },
                    suffixIcon: const Icon(
                      Icons.search,
                      color: AppColors.blackColor,
                    ),
                  )),
                  widthBox10(),
                  // StreamBuilder<bool>(
                  //   stream: OrientationHelper.autoRotateStream,
                  //   builder: (context, snapshot) {
                  //     final isOn = snapshot.data ?? false;
                  //     return InkWell(
                  //       onTap: () {
                  //         ScaffoldMessenger.of(context).showSnackBar(
                  //           SnackBar(content: Text(isOn ? "Auto-rotate ON" : "Auto-rotate OFF")),
                  //         );
                  //       },
                  //       child: Icon(
                  //         Icons.screen_rotation,
                  //         color: isOn ? Colors.green : Colors.red,
                  //       ),
                  //     );
                  //   },
                  // ),
                  InkWell(
                    onTap: () async {
                      // bool isOn = await OrientationHelper.isAutoRotateOn();
                      // if (isOn) {
                      //   Fluttertoast.showToast(msg: "✅ Auto-rotate is ON");
                      // } else {
                      //   Fluttertoast.showToast(msg: "❌ Auto-rotate is OFF");
                      // }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddUpdateMoveiScreen(),
                        ),
                      );
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
              heightBox10(),
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<GetAllMovieCategoryCubit, GetAllCategoryState>(
                      builder: (context, state) {
                        if (state is GetAllCategoryLoadedState) {
                          final genres =
                              state.model.categories?.map((datum) => datum.name).whereType<String>().toList() ?? [];
                          return CustomDropdown(
                            items: genres,
                            selectedValue: selectedCategory,
                            hinttext: "select category",
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                                final selectedDatum =
                                    state.model.categories?.firstWhere((datum) => datum.name == value);
                                selectedCategoryId = selectedDatum?.id;
                                print("Selected Datum ID: ${selectedDatum?.id}");
                                context.read<GetAllMovieCubit>().getAllMovie(categoryId: selectedDatum?.id);
                              });
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  widthBox10(),
                  Expanded(
                    child: BlocBuilder<GetAllLanguageCubit, GetAllLanguageState>(
                      builder: (context, state) {
                        if (state is GetAllLanguageLoadedState) {
                          final languageNames =
                              state.model.data?.map((datum) => datum.name).whereType<String>().toList() ?? [];
                          return CustomDropdown(
                            items: languageNames,
                            hinttext: "select language",
                            selectedValue: selectedLanguage,
                            onChanged: (value) {
                              setState(() {
                                selectedLanguage = value;
                                final selectedDatum = state.model.data?.firstWhere((datum) => datum.name == value);
                                print("Selected Datum ID: ${selectedDatum?.id}");
                                selectedLanguageId = selectedDatum?.id;
                                context.read<GetAllMovieCubit>().getAllMovie(languageId: selectedDatum?.id);
                              });
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
              heightBox10(),
              Row(
                children: [
                  BlocBuilder<GetAllMovieCubit, GetAllMovieState>(
                    builder: (context, state) {
                      if (state is GetAllMovieLaodedState) {
                        return Expanded(
                          child: Row(
                            children: [
                              Checkbox(
                                fillColor: const WidgetStatePropertyAll(
                                  AppColors.whiteColor,
                                ),
                                side: const BorderSide(color: AppColors.greyColor),
                                value: isSelectAll,
                                checkColor: AppColors.blackColor,
                                onChanged: (value) {
                                  setState(() {
                                    isSelectAll = value ?? false;

                                    if (isSelectAll) {
                                      selectedMovieIds = state.model.data?.movies?.map((e) => e.id!).toList() ?? [];
                                    } else {
                                      selectedMovieIds.clear();
                                    }
                                  });
                                },
                              ),
                              const TextWidget(
                                text: "Select All",
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  widthBox10(),
                  if (selectedMovieIds.isNotEmpty)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => DeleteDialog(
                              onCancelPressed: () {
                                Navigator.pop(context);
                              },
                              onDeletePressed: () {
                                context.read<DeleteMovieCubit>().deleteMovie(selectedMovieIds);
                              },
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  widthBox10(),
                  Expanded(
                    child: CustomOutlinedButton(
                      onPressed: () {
                        movieNameController.clear();
                        selectedCategoryId = null;
                        selectedLanguageId = null;
                        selectedCategory = null;
                        selectedLanguage = null;
                        context.read<GetAllMovieCubit>().getAllMovie();
                        setState(() {});
                      },
                      buttonText: "Reset Filter",
                    ),
                  ),
                ],
              ),
              heightBox20(),
              BlocListener<UpdateMovieCubit, UpdateMovieState>(
                listener: (context, state) {
                  if (state is UpdateMovieErrorState) {
                    Fluttertoast.showToast(msg: state.error);
                    return;
                  }

                  if (state is UpdateMovieLoadedState) {
                    Fluttertoast.showToast(msg: "Update Movie Successfully");
                    context.read<GetAllMovieCubit>().getAllMovie();
                  }
                },
                child: BlocListener<DeleteMovieCubit, DeleteMovieState>(
                  listener: (context, state) {
                    if (state is DeleteMovieErrorState) {
                      Fluttertoast.showToast(msg: state.error);
                      return;
                    }

                    if (state is DeleteMovieLoadedState) {
                      selectedMovieIds.clear();
                      isSelectAll = false;
                      setState(() {});
                      Fluttertoast.showToast(msg: "Delete Successfully");
                      context.read<GetAllMovieCubit>().getAllMovie();
                      Navigator.pop(context);
                    }
                  },
                  child: BlocBuilder<GetAllMovieCubit, GetAllMovieState>(
                    builder: (context, state) {
                      if (state is GetAllMovieLoadingState) {
                        return const Center(
                          child: CustomCircularProgressIndicator(),
                        );
                      }

                      if (state is GetAllMovieErrorState) {
                        return const CustomErrorWidget();
                      }

                      if (state is GetAllMovieLaodedState) {
                        return state.model.data?.movies?.isEmpty ?? true
                            ? const CustomEmptyWidget()
                            : GridView.builder(
                                itemCount: state.model.data?.movies?.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  childAspectRatio: 1,
                                  mainAxisExtent: 230,
                                ),
                                itemBuilder: (context, index) {
                                  final item = state.model.data?.movies?[index];
                                  return Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: (item?.coverImg == null || item!.coverImg!.isEmpty)
                                              ? AssetImage(noImgFound) as ImageProvider
                                              : NetworkImage("${item.coverImg}"),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 40,
                                                  width: 40,
                                                  child: Checkbox(
                                                    side: const BorderSide(
                                                      color: AppColors.whiteColor,
                                                    ),
                                                    shape: const CircleBorder(
                                                      side: BorderSide(
                                                        color: AppColors.whiteColor,
                                                      ),
                                                    ),
                                                    fillColor: const WidgetStatePropertyAll(AppColors.greyColor),
                                                    focusColor: AppColors.whiteColor,
                                                    value: selectedMovieIds.contains(item?.id),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        if (value == true) {
                                                          selectedMovieIds.add(item!.id!);
                                                        } else {
                                                          selectedMovieIds.remove(item!.id!);
                                                        }

                                                        // Handle Select All toggle based on current selection
                                                        final totalMovies = state.model.data?.movies?.length ?? 0;
                                                        isSelectAll = selectedMovieIds.length == totalMovies;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                const Spacer(),
                                                Switch(
                                                  trackOutlineColor: const WidgetStatePropertyAll(AppColors.whiteColor),
                                                  activeColor: Colors.transparent,
                                                  thumbColor: const WidgetStatePropertyAll(AppColors.zGreenColor),
                                                  value: item?.status ?? false,
                                                  onChanged: (value) {
                                                    context.read<UpdateMovieCubit>().updateMovies(
                                                          id: item?.id ?? "",
                                                          status: value,
                                                        );
                                                  },
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextWidget(
                                                  text: "${item?.movieName}",
                                                  color: AppColors.whiteColor,
                                                  fontSize: 14,
                                                ),
                                                heightBox10(),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(12),
                                                        child: BackdropFilter(
                                                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                          child: Container(
                                                            padding: const EdgeInsets.all(8),
                                                            decoration: BoxDecoration(
                                                              color: Colors.white.withOpacity(0.2),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            child: svgAsset(
                                                              assetName: AppImages.eyeSvg,
                                                              height: 20,
                                                              width: 20,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    widthBox5(),
                                                    Expanded(
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(12),
                                                        child: BackdropFilter(
                                                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                          child: InkWell(
                                                            onTap: () {
                                                              context.read<UpdateMovieCubit>().updateMovies(
                                                                    id: item?.id ?? "",
                                                                    isHighlighted:
                                                                        item?.isHighlighted == true ? false : true,
                                                                  );
                                                            },
                                                            child: Container(
                                                              padding: const EdgeInsets.all(8),
                                                              decoration: BoxDecoration(
                                                                color: Colors.white.withOpacity(0.2),
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              child: svgAsset(
                                                                assetName: AppImages.starSvg,
                                                                height: 20,
                                                                width: 20,
                                                                color: item?.isHighlighted ?? false
                                                                    ? Colors.amber
                                                                    : AppColors.whiteColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    widthBox5(),
                                                    Expanded(
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(12),
                                                        child: BackdropFilter(
                                                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => AddUpdateMoveiScreen(
                                                                    id: item?.id,
                                                                    model: item,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              padding: const EdgeInsets.all(8),
                                                              decoration: BoxDecoration(
                                                                color: Colors.white.withOpacity(0.2),
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              child: svgAsset(
                                                                assetName: AppImages.zeditSvg,
                                                                height: 20,
                                                                width: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    widthBox5(),
                                                    Expanded(
                                                      child: InkWell(
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
                                                                      .read<DeleteMovieCubit>()
                                                                      .deleteMovie([item?.id ?? ""]);
                                                                },
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(12),
                                                          child: BackdropFilter(
                                                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                            child: Container(
                                                              padding: const EdgeInsets.all(8),
                                                              decoration: BoxDecoration(
                                                                color: Colors.white.withOpacity(0.2),
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              child: svgAsset(
                                                                assetName: AppImages.trashSvg,
                                                                height: 20,
                                                                width: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ));
                                },
                              );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
              heightBox15(),
              BlocBuilder<GetAllMovieCubit, GetAllMovieState>(
                builder: (context, state) {
                  if (state is GetAllMovieLaodedState) {
                    return CustomPagination(
                        currentPage: currentPage,
                        totalPages: state.model.data?.totalPages ?? 0,
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

  _showRatingDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.whiteColor,
          surfaceTintColor: AppColors.whiteColor,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      heightBox15(),
                      const TextWidget(
                        text: 'Add Rating',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      heightBox30(),
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
                      heightBox30(),
                    ],
                  ),
                  RatingBar.builder(
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: index <= rating ? Colors.orange : Colors.grey,
                      size: 100,
                    ),
                    onRatingUpdate: (ratingvalue) {
                      setState(() {
                        rating = ratingvalue;
                      });
                    },
                    initialRating: rating,
                    allowHalfRating: true,
                    minRating: 0.5,
                    itemCount: 5,
                    itemSize: 30,
                    updateOnDrag: true,
                  ),
                  Text("(${rating.toString()})"),
                  heightBox30(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
