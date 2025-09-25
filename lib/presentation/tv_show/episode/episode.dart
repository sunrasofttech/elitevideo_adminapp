import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:elite_admin/bloc/tv_show/episode_tv_show/delete_episode/delete_episode_cubit.dart';
import 'package:elite_admin/bloc/tv_show/episode_tv_show/get_all_episode/get_all_episode_cubit.dart';
import 'package:elite_admin/bloc/tv_show/episode_tv_show/update_episode/update_episode_cubit.dart';
import 'package:elite_admin/bloc/tv_show/season_tv_show/get_all_season/get_all_season_cubit.dart';
import 'package:elite_admin/bloc/tv_show/tv_show/get_all_tv_show/get_all_tv_show_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/presentation/tv_show/episode/add_update_episode_screen.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_dropdown.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/custom_pagination.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/delete_dialog.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';
import '../../../constant/image.dart';

class TvShowEpisodeScreen extends StatefulWidget {
  const TvShowEpisodeScreen({super.key});

  @override
  State<TvShowEpisodeScreen> createState() => _TvShowEpisodeScreenState();
}

class _TvShowEpisodeScreenState extends State<TvShowEpisodeScreen> with Utility {
  String? selectedSeries;
  String? selectedSeason;
  int currentPage = 1;
  String? selectedSeriesId;
  String? selectedSeasonId;
  List<String> selectedMovieIds = [];
  bool isSelectAll = false;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<GetAllTvShowEpisodeCubit>().getAllEpisode();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: ListView(
            children: [
              const TextWidget(
                text: "Manage Episode",
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              heightBox15(),
              Row(
                children: [
                  Expanded(
                      child: TextFormFieldWidget(
                    isSuffixIconShow: true,
                    backgroundColor: AppColors.whiteColor,
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
                          builder: (context) => const AddUpdateTvShowEpisodeScreen(),
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
                    child: BlocBuilder<GetAllTvShowSeriesCubit, GetAllSeriesState>(
                      builder: (context, state) {
                        if (state is GetAllSeriesLoadedState) {
                          final languageNames =
                              state.model.data?.map((datum) => datum.seriesName).whereType<String>().toList() ?? [];
                          return CustomDropdown(
                            items: languageNames,
                            hinttext: "select Series",
                            selectedValue: selectedSeries,
                            onChanged: (value) {
                              setState(() {
                                selectedSeries = value;
                                final selectedDatum =
                                    state.model.data?.firstWhere((datum) => datum.seriesName == value);
                                print("Selected Datum ID: ${selectedDatum?.id}");
                                selectedSeriesId = selectedDatum?.id;
                                context.read<GetAllTvShowEpisodeCubit>().getAllEpisode(
                                      seriesId: selectedDatum?.id,
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
                    child: BlocBuilder<GetAllTvShowSeasonCubit, GetAllSeasonState>(
                      builder: (context, state) {
                        if (state is GetAllSeasonLoadedState) {
                          final genres =
                              state.model.data?.map((datum) => datum.seasonName).whereType<String>().toList() ?? [];
                          return CustomDropdown(
                            items: genres,
                            selectedValue: selectedSeason,
                            hinttext: "select Season",
                            onChanged: (value) {
                              setState(() {
                                selectedSeason = value;
                                final selectedDatum =
                                    state.model.data?.firstWhere((datum) => datum.seasonName == value);
                                selectedSeasonId = selectedDatum?.id;
                                print("Selected Datum ID: ${selectedDatum?.id}");
                                context.read<GetAllTvShowEpisodeCubit>().getAllEpisode(
                                      seasonId: selectedDatum?.id,
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
              heightBox10(),
              Row(
                children: [
                  BlocBuilder<GetAllTvShowEpisodeCubit, GetAllEpisodeState>(
                    builder: (context, state) {
                      if (state is GetAllEpisodeLoadedState) {
                        return SizedBox(
                          child: Row(
                            children: [
                              Checkbox(
                                  value: isSelectAll,
                                  checkColor: AppColors.whiteColor,
                                  fillColor: const WidgetStatePropertyAll(AppColors.blackColor),
                                  onChanged: (value) {
                                    setState(() {
                                      isSelectAll = value ?? false;

                                      if (isSelectAll) {
                                        selectedMovieIds = state.model.data?.map((e) => e.id ?? "").toList() ?? [];
                                      } else {
                                        selectedMovieIds.clear();
                                      }
                                    });
                                  }),
                              const TextWidget(
                                text: "Select All",
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  widthBox10(),
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
                                context.read<DeleteTvShowEpisodeCubit>().deleteEpisode(selectedMovieIds);
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
                        selectedSeasonId = null;
                        selectedSeriesId = null;
                        context.read<GetAllTvShowEpisodeCubit>().getAllEpisode();
                        setState(() {});
                      },
                      buttonText: "Reset Filter",
                    ),
                  ),
                ],
              ),
              heightBox10(),
              BlocListener<UpdateTvShowEpisodeCubit, UpdateEpisodeState>(
                listener: (context, state) {
                  if (state is UpdateEpisodeErrorState) {
                    Fluttertoast.showToast(msg: state.error);
                    return;
                  }

                  if (state is UpdateEpisodeLoadedState) {
                    context.read<GetAllTvShowEpisodeCubit>().getAllEpisode();
                    Fluttertoast.showToast(msg: "Update Successfully");
                  }
                },
                child: BlocListener<DeleteTvShowEpisodeCubit, DeleteEpisodeState>(
                  listener: (context, state) {
                    if (state is DeleteEpisodeErrorState) {
                      Fluttertoast.showToast(msg: state.error);
                      return;
                    }

                    if (state is DeleteEpisodeLaodedState) {
                      Fluttertoast.showToast(msg: "Delete Sucessfully");
                      context.read<GetAllTvShowEpisodeCubit>().getAllEpisode();
                    }
                  },
                  child: BlocBuilder<GetAllTvShowEpisodeCubit, GetAllEpisodeState>(
                    builder: (context, state) {
                      if (state is GetAllEpisodeLoadingState) {
                        return const Center(
                          child: CustomCircularProgressIndicator(),
                        );
                      }

                      if (state is GetAllEpisodeErrorState) {
                        return const CustomErrorWidget();
                      }

                      if (state is GetAllEpisodeLoadedState) {
                        return GridView.builder(
                          itemCount: state.model.data?.length ?? 0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: 1,
                            mainAxisExtent: 170,
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
                                      Checkbox(
                                        fillColor: const WidgetStatePropertyAll(AppColors.blackColor),
                                        value: selectedMovieIds.contains(item?.id),
                                        onChanged: (value) {
                                          setState(() {
                                            if (value == true) {
                                              selectedMovieIds.add(item!.id!);
                                            } else {
                                              selectedMovieIds.remove(item!.id!);
                                            }
                                            final totalMovies = state.model.data?.length ?? 0;
                                            isSelectAll = selectedMovieIds.length == totalMovies;
                                          });
                                        },
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextWidget(
                                            text: "${item?.episodeName}",
                                            color: AppColors.whiteColor,
                                            fontSize: 14,
                                          ),
                                          heightBox10(),
                                          Row(
                                            children: [
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
                                                            builder: (context) => AddUpdateTvShowEpisodeScreen(
                                                              id: item?.id ?? "",
                                                              item: item,
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
                                                            context.read<DeleteTvShowEpisodeCubit>().deleteEpisode(
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
                                              widthBox5(),
                                              Expanded(
                                                child: Switch(
                                                  thumbColor: const WidgetStatePropertyAll(AppColors.zGreenColor),
                                                  activeColor: Colors.transparent,
                                                  value: item?.status ?? false,
                                                  onChanged: (value) {
                                                    context
                                                        .read<UpdateTvShowEpisodeCubit>()
                                                        .updateEpisode(id: item?.id ?? "", status: value);
                                                  },
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
              BlocBuilder<GetAllTvShowEpisodeCubit, GetAllEpisodeState>(
                builder: (context, state) {
                  if (state is GetAllEpisodeLoadedState) {
                    return CustomPagination(
                        currentPage: currentPage,
                        totalPages: state.model.pagination?.totalPages ?? 0,
                        onPageChanged: (e) {
                          setState(() {
                            currentPage = e;
                          });
                          context.read<GetAllTvShowEpisodeCubit>().getAllEpisode(
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
