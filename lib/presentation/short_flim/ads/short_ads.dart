import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:elite_admin/bloc/ads/get_all_ads/get_all_ads_cubit.dart';
import 'package:elite_admin/bloc/ads/get_all_ads/get_all_ads_model.dart';
import 'package:elite_admin/bloc/short_film/ads/delete_short_film_ads/delete_short_film_ads_cubit.dart';
import 'package:elite_admin/bloc/short_film/ads/get_short_film_ads/get_short_flim_ads_cubit.dart';
import 'package:elite_admin/bloc/short_film/ads/post_short_flim_ads/post_short_film_ads_cubit.dart';
import 'package:elite_admin/bloc/short_film/ads/update_short_film_ads/update_short_film_ads_cubit.dart';
import 'package:elite_admin/bloc/short_film/get_all_short_flim/get_all_short_film_model.dart' as episode;
import 'package:elite_admin/bloc/short_film/get_all_short_flim/get_all_short_film_cubit.dart';
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

class ShortFlimAdsScreen extends StatefulWidget {
  const ShortFlimAdsScreen({super.key});

  @override
  State<ShortFlimAdsScreen> createState() => _ShortFlimAdsScreenState();
}

class _ShortFlimAdsScreenState extends State<ShortFlimAdsScreen> with Utility {
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
                    text: "Short Films Ads",
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  InkWell(
                    onTap: () {
                      _addUpdateWebSeriesPopUp();
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
              BlocListener<DeleteShortFilmAdsCubit, DeleteShortFilmAdsState>(
                listener: (context, state) {
                  if (state is DeleteShortFilmAdsErrorState) {
                    Fluttertoast.showToast(msg: state.error);
                    return;
                  }

                  if (state is DeleteShortFilmAdsLoadedState) {
                    Fluttertoast.showToast(msg: "Delete Successfully");
                    context.read<GetShortFlimAdsCubit>().getAllWebAds();
                  }
                },
                child: BlocBuilder<GetShortFlimAdsCubit, GetShortFlimAdsState>(
                  builder: (context, state) {
                    if (state is GetShortFlimAdsLoadingState) {
                      return const Center(
                        child: CustomCircularProgressIndicator(),
                      );
                    }

                    if (state is GetShortFlimAdsErrorState) {
                      return const Center(
                        child: CustomErrorWidget(),
                      );
                    }
                    if (state is GetShortFlimAdsLoadedState) {
                      return state.model.data?.isEmpty ?? true
                          ? const CustomEmptyWidget()
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
                                      text: "Short Film Name : ${data?.shortfilm?.shortFilmTitle ?? ""}",
                                    ),
                                    subtitle: TextWidget(
                                      text: "Ads Name : ${data?.videoAd?.title ?? ""}",
                                    ),
                                    trailing: Wrap(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _addUpdateWebSeriesPopUp(
                                                id: data?.id, movieId: data?.shortfilmId, videoId: data?.videoAdId);
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
                                                          .read<DeleteShortFilmAdsCubit>()
                                                          .deleteShortFilm(data?.id ?? "");
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
              BlocBuilder<GetShortFlimAdsCubit, GetShortFlimAdsState>(
                builder: (context, state) {
                  if (state is GetShortFlimAdsLoadedState) {
                    return CustomPagination(
                        currentPage: currentPage,
                        totalPages: state.model.pagination?.totalPages ?? 0,
                        onPageChanged: (e) {
                          setState(() {
                            currentPage = e;
                          });
                          context.read<GetShortFlimAdsCubit>().getAllWebAds(
                                page: currentPage,
                              );
                        });
                  }
                  return const SizedBox();
                },
              ),
              heightBox15()
            ],
          ),
        ),
      ),
    );
  }

  _addUpdateWebSeriesPopUp({
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
                          text: "Short Films Ads",
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
                            text: "Select Short Film Movies",
                          ),
                          heightBox10(),
                          BlocBuilder<GetAllShortFilmCubit, GetAllShortFilmState>(
                            builder: (context, state) {
                              if (state is GetAllShortFilmLoadingState) {
                                return const Center(
                                  child: CustomCircularProgressIndicator(),
                                );
                              }

                              if (state is GetAllShortFilmLoadedState) {
                                final movies = state.model.data ?? [];
                                final movieNames = movies.map((e) => e.shortFilmTitle ?? "").toList();
                                return DropdownSearch<String>(
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    menuProps: const MenuProps(
                                      backgroundColor: AppColors.whiteColor,
                                    ),
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        fillColor: AppColors.blackColor,
                                        hintText: "Search Episode Type",
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
                                      hintText: "Short Film Type",
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
                                            orElse: () => episode.Datum(),
                                          )
                                          .shortFilmTitle
                                      : null,
                                  onChanged: (String? newValue) {
                                    final selectedMovie = movies.firstWhere(
                                      (e) => e.shortFilmTitle == newValue,
                                      orElse: () => episode.Datum(),
                                    );
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
                          BlocConsumer<UpdateShortFilmAdsCubit, UpdateShortFilmAdsState>(
                            listener: (context, state) {
                              if (state is UpdateShortFilmAdsErrorState) {
                                Fluttertoast.showToast(msg: state.error);
                                return;
                              }

                              if (state is UpdateShortFilmAdsLoadedState) {
                                Fluttertoast.showToast(msg: "Update Sucessfully");
                                context.read<GetShortFlimAdsCubit>().getAllWebAds();
                                Navigator.pop(context);
                              }
                            },
                            builder: (context, updateState) {
                              return BlocConsumer<PostShortFilmAdsCubit, PostShortFilmAdsState>(
                                listener: (context, state) {
                                  if (state is PostShortFilmAdsErrorState) {
                                    Fluttertoast.showToast(msg: state.error);
                                    return;
                                  }

                                  if (state is PostShortFilmAdsLaodedState) {
                                    Fluttertoast.showToast(msg: "Post Web Ads Successfully");
                                    context.read<GetShortFlimAdsCubit>().getAllWebAds();
                                    Navigator.pop(context);
                                  }
                                },
                                builder: (context, state) {
                                  return CustomOutlinedButton(
                                    inProgress: (updateState is UpdateShortFilmAdsLoadingState ||
                                        state is PostShortFilmAdsLoadingState),
                                    onPressed: () {
                                      if (id != null) {
                                        context.read<UpdateShortFilmAdsCubit>().updateShortFilmAds(
                                            id: id, movieId: selectedMovieId ?? "", videoAdId: selectedVideoId ?? "");
                                        return;
                                      }

                                      context.read<PostShortFilmAdsCubit>().postShortFilmAds(
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
