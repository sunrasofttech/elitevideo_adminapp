import 'package:dropdown_search/dropdown_search.dart';
import 'package:elite_admin/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elite_admin/bloc/ads/get_all_ads/get_all_ads_cubit.dart';
import 'package:elite_admin/bloc/ads/get_all_ads/get_all_ads_model.dart';
import 'package:elite_admin/bloc/movie/movie%20ads/delete_movie_ads/delete_movie_ads_cubit.dart';
import 'package:elite_admin/bloc/movie/movie%20ads/get_all_movie_ads/get_all_movie_ads_cubit.dart';
import 'package:elite_admin/bloc/movie/movie%20ads/post_movie_ads/post_movie_ads_cubit.dart';
import 'package:elite_admin/bloc/movie/movie%20ads/update_movie_ads/update_movie_ads_cubit.dart';
import 'package:elite_admin/bloc/movie/upload_movie/get_all_movie/get_all_movie_cubit.dart';
import 'package:elite_admin/bloc/movie/upload_movie/get_all_movie/get_all_movie_model.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_empty_widget.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/custom_pagination.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/delete_dialog.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class MovieAdsScreen extends StatefulWidget {
  const MovieAdsScreen({super.key});

  @override
  State<MovieAdsScreen> createState() => _MovieAdsScreenState();
}

class _MovieAdsScreenState extends State<MovieAdsScreen> with Utility {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextWidget(
                    text: "Movie Ads",
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  InkWell(
                    onTap: () {
                      _addUpdateMovieAdsPopUp();
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
              heightBox15(),
              BlocListener<DeleteMovieAdsCubit, DeleteMovieAdsState>(
                listener: (context, state) {
                  if (state is DeleteMovieAdsErrorState) {
                   showMessage(context,  state.error);
                    return;
                  }

                  if (state is DeleteMovieAdsLoadedState) {
                   showMessage(context,  "Delete Successfully");
                    context.read<GetAllMovieAdsCubit>().getAllMovies(page: currentPage);
                  }
                },
                child: BlocBuilder<GetAllMovieAdsCubit, GetAllMovieAdsState>(
                  builder: (context, state) {
                    if (state is GetAllMovieAdsLoadingState) {
                      return const Center(
                        child: CustomCircularProgressIndicator(),
                      );
                    }

                    if (state is GetAllMovieAdsErrorState) {
                      return const Center(
                        child: CustomErrorWidget(),
                      );
                    }
                    if (state is GetAllMovieAdsLaodedState) {
                      return state.model.data?.isEmpty ?? false
                          ? const Center(
                              child: CustomEmptyWidget(),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var data = state.model.data?[index];
                                return Card(
                                  surfaceTintColor: AppColors.whiteColor,
                                  color: AppColors.whiteColor,
                                  child: ListTile(
                                    title: TextWidget(
                                      text: "Movie Name : ${data?.movie?.movieName ?? ""}",
                                    ),
                                    subtitle: TextWidget(
                                      text: "Ads Name : ${data?.videoAd?.title ?? ""}",
                                    ),
                                    trailing: Wrap(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _addUpdateMovieAdsPopUp(
                                                id: data?.id, movieId: data?.movieId, videoId: data?.videoAdId);
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
                                                          .read<DeleteMovieAdsCubit>()
                                                          .deleteMovieAds(data?.id ?? "");
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            child: svgAsset(assetName: AppImages.deleteSvg)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: state.model.data?.length,
                            );
                    }
                    return Container();
                  },
                ),
              ),
              heightBox15(),
              BlocBuilder<GetAllMovieAdsCubit, GetAllMovieAdsState>(
                builder: (context, state) {
                  if (state is GetAllMovieAdsLaodedState) {
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

  _addUpdateMovieAdsPopUp({
    String? videoId,
    String? movieId,
    String? id,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        String? selectedMovieId = movieId;
        String? selectedVideoId = videoId;
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
                          text: "Movie Ads",
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
                            text: "Select Movies",
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
                                final movies = state.model.data?.movies ?? [];
                                final movieNames = movies.map((e) => e.movieName ?? "").toList();
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
                                    return movieNames;
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
                                  selectedItem: selectedMovieId != null
                                      ? movies
                                          .firstWhere(
                                            (e) => e.id == selectedMovieId,
                                            orElse: () => Movie(),
                                          )
                                          .movieName
                                      : null,
                                  onChanged: (String? newValue) {
                                    final selectedMovie =
                                        movies.firstWhere((e) => e.movieName == newValue, orElse: () => Movie());
                                    setState(() {
                                      selectedMovieId = selectedMovie.id;
                                    });
                                  },
                                );
                              }

                              return const SizedBox();
                            },
                          ),
                          heightBox15(),
                          const TextWidget(
                            text: "Select Ads Video",
                          ),
                          heightBox10(),
                          BlocBuilder<GetAllAdsCubit, GetAllAdsState>(
                            builder: (context, state) {
                              if (state is GetAllAdsLoadingState) {
                                return const Center(
                                  child: CustomCircularProgressIndicator(),
                                );
                              }

                              if (state is GetAllAdsLaodedState) {
                                final movies = state.model.data ?? [];
                                final movieNames = movies.map((e) => e.title ?? "").toList();
                                return DropdownSearch<String>(
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    menuProps: const MenuProps(
                                      backgroundColor: AppColors.whiteColor,
                                    ),
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        fillColor: AppColors.blackColor,
                                        hintText: "Search Ads Type",
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
                                    return movieNames;
                                  },
                                  decoratorProps: const DropDownDecoratorProps(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.greyColor),
                                      ),
                                      hintText: "Ads Type",
                                      hintStyle: TextStyle(
                                        fontSize: 11,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.greyColor),
                                      ),
                                    ),
                                  ),
                                  selectedItem: selectedVideoId != null
                                      ? movies
                                              .firstWhere(
                                                (e) => e.id == selectedVideoId,
                                                orElse: () => Datum(),
                                              )
                                              .title ??
                                          ""
                                      : null,
                                  onChanged: (String? newValue) {
                                    final selectedMovie =
                                        movies.firstWhere((e) => e.title == newValue, orElse: () => Datum());
                                    setState(() {
                                      selectedVideoId = selectedMovie.id;
                                    });
                                  },
                                );
                              }

                              return const SizedBox();
                            },
                          ),
                          heightBox15(),
                          BlocConsumer<UpdateMovieAdsCubit, UpdateMovieAdsState>(
                            listener: (context, state) {
                              if (state is UpdateMovieAdsErrorState) {
                               showMessage(context,  state.error);
                                return;
                              }

                              if (state is UpdateMovieAdsLaodedState) {
                               showMessage(context,  "Update Sucessfully");
                                context.read<GetAllMovieAdsCubit>().getAllMovies(page: currentPage);
                                Navigator.pop(context);
                              }
                            },
                            builder: (context, updateState) {
                              return BlocConsumer<PostMovieAdsCubit, PostMovieAdsState>(
                                listener: (context, state) {
                                  if (state is PostMovieAdsErrorState) {
                                   showMessage(context,  state.error);
                                    return;
                                  }

                                  if (state is PostMovieAdsLoadedState) {
                                   showMessage(context,  "Post castCrew Successfully");
                                    context.read<GetAllMovieAdsCubit>().getAllMovies();
                                    Navigator.pop(context);
                                  }
                                },
                                builder: (context, state) {
                                  return CustomOutlinedButton(
                                    inProgress: (updateState is UpdateMovieAdsLoadingState ||
                                        state is PostMovieAdsLoadingState),
                                    onPressed: () {
                                      if (id != null) {
                                        context.read<UpdateMovieAdsCubit>().updateMovieAds(
                                            id: id, movieId: selectedMovieId ?? "", videoAdId: selectedVideoId ?? "");
                                        return;
                                      }

                                      context.read<PostMovieAdsCubit>().postMovieAds(
                                            selectedMovieId ?? "",
                                            selectedVideoId ?? "",
                                          );
                                    },
                                    buttonText: id != null ? 'Save Movie Ads' : 'Add Movie Ads',
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
