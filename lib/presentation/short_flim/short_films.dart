import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:elite_admin/bloc/movie/genre/get_all_genre/get_all_genre_cubit.dart';
import 'package:elite_admin/bloc/movie/language/get_all_language/get_all_language_cubit.dart';
import 'package:elite_admin/bloc/short_film/delete_film/delete_film_cubit.dart';
import 'package:elite_admin/bloc/short_film/get_all_short_flim/get_all_short_film_cubit.dart';
import 'package:elite_admin/bloc/short_film/update/update_film_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/presentation/short_flim/add_update_shortflim.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_dropdown.dart';
import 'package:elite_admin/utils/widget/custom_empty_widget.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/custom_pagination.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/delete_dialog.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class ShortFilmsScreen extends StatefulWidget {
  const ShortFilmsScreen({super.key});

  @override
  State<ShortFilmsScreen> createState() => _ShortFilmsScreenState();
}

class _ShortFilmsScreenState extends State<ShortFilmsScreen> with Utility {
  String? selectedLanguage;
  String? selectedLanguageId;
  String? selectedGenre;
  String? selectedGenreId;
  String? selectedCategory;
  String? selectedCategoryId;
  List<Map<String, dynamic>> castCrewList = [];
  double rating = 0;
  final TextEditingController searchController = TextEditingController();
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<GetAllShortFilmCubit>().getAllShortFilm();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: ListView(
            children: [
              const TextWidget(
                text: "Manage Short Films",
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              heightBox15(),
              Row(
                children: [
                  Expanded(
                      child: TextFormFieldWidget(
                    controller: searchController,
                    onChanged: (p0) {
                      context.read<GetAllShortFilmCubit>().getAllShortFilm(
                            shortFilmTitle: p0,
                          );
                    },
                    isSuffixIconShow: true,
                    suffixIcon: const Icon(
                      Icons.search,
                      color: AppColors.blackColor,
                    ),
                  )),
                  widthBox10(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddUpdateShortFlimScreen(),
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
                                context.read<GetAllShortFilmCubit>().getAllShortFilm(
                                      language: selectedDatum?.id,
                                    );
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
                    child: BlocBuilder<GetAllGenreCubit, GetAllGenreState>(
                      builder: (context, state) {
                        if (state is GetAllGenreLaodedState) {
                          final genres =
                              state.model.data?.map((datum) => datum.name).whereType<String>().toList() ?? [];
                          return CustomDropdown(
                            items: genres,
                            selectedValue: selectedCategory,
                            hinttext: "select category",
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                                final selectedDatum = state.model.data?.firstWhere((datum) => datum.name == value);
                                selectedCategoryId = selectedDatum?.id;
                                context.read<GetAllShortFilmCubit>().getAllShortFilm(
                                      genre: selectedDatum?.id,
                                    );
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
              heightBox20(),
              BlocListener<UpdateFilmCubit, UpdateFilmState>(
                listener: (context, state) {
                  if (state is UpdateFilmErrorState) {
                    Fluttertoast.showToast(msg: state.error);
                    return;
                  }

                  if (state is UpdateFilmLoadedState) {
                    Fluttertoast.showToast(msg: "Update Movie Successfully");
                    context.read<GetAllShortFilmCubit>().getAllShortFilm();
                  }
                },
                child: BlocListener<DeleteFilmCubit, DeleteFilmState>(
                  listener: (context, state) {
                    if (state is DeleteFilmErrorState) {
                      Fluttertoast.showToast(msg: state.error);
                      return;
                    }

                    if (state is DeleteFilmLoadedState) {
                      Fluttertoast.showToast(msg: "Delete Successfully");
                      context.read<GetAllShortFilmCubit>().getAllShortFilm();
                      Navigator.pop(context);
                    }
                  },
                  child: BlocBuilder<GetAllShortFilmCubit, GetAllShortFilmState>(
                    builder: (context, state) {
                      if (state is GetAllShortFilmLoadingState) {
                        return const Center(
                          child: CustomCircularProgressIndicator(),
                        );
                      }

                      if (state is GetAllShortFilmErrorState) {
                        return const CustomErrorWidget();
                      }

                      if (state is GetAllShortFilmLoadedState) {
                        return state.model.data?.isEmpty ?? true
                            ? const CustomEmptyWidget()
                            : GridView.builder(
                                itemCount: state.model.data?.length,
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
                                  final item = state.model.data?[index];
                                  return Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage("${item?.coverImg}"),
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
                                                // SizedBox(
                                                //   height: 40,
                                                //   width: 40,
                                                //   child: Checkbox(
                                                //     side: const BorderSide(
                                                //       color: AppColors.whiteColor,
                                                //     ),
                                                //     shape: const CircleBorder(
                                                //       side: BorderSide(
                                                //         color: AppColors.whiteColor,
                                                //       ),
                                                //     ),
                                                //     fillColor: const WidgetStatePropertyAll(AppColors.greyColor),
                                                //     focusColor: AppColors.whiteColor,
                                                //     value: false,
                                                //     onChanged: (value) {},
                                                //   ),
                                                // ),
                                                const Spacer(),
                                                Switch(
                                                  trackOutlineColor: const WidgetStatePropertyAll(AppColors.whiteColor),
                                                  activeColor: Colors.transparent,
                                                  thumbColor: const WidgetStatePropertyAll(AppColors.zGreenColor),
                                                  value: item?.status ?? false,
                                                  onChanged: (value) {
                                                    context.read<UpdateFilmCubit>().updateShortFilm(
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
                                                  text: "${item?.shortFilmTitle}",
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
                                                              context.read<UpdateFilmCubit>().updateShortFilm(
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
                                                                  builder: (context) => AddUpdateShortFlimScreen(
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
                                                                  context.read<DeleteFilmCubit>().deleteShortFilm(
                                                                    [item?.id ?? ""],
                                                                  );
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
              BlocBuilder<GetAllShortFilmCubit, GetAllShortFilmState>(
                builder: (context, state) {
                  if (state is GetAllShortFilmLoadedState) {
                    return CustomPagination(
                        currentPage: currentPage,
                        totalPages: state.model.pagination?.totalPages ?? 0,
                        onPageChanged: (e) {
                          setState(() {
                            currentPage = e;
                          });
                          context.read<GetAllShortFilmCubit>().getAllShortFilm(
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
}
