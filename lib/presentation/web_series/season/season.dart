import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:elite_admin/bloc/web_series/season/delete_season/delete_season_cubit.dart';
import 'package:elite_admin/bloc/web_series/season/get_all_season/get_all_season_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/presentation/web_series/season/add_and_update_season.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_empty_widget.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/custom_pagination.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/delete_dialog.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class SeasonScreen extends StatefulWidget {
  const SeasonScreen({super.key});

  @override
  State<SeasonScreen> createState() => _SeasonScreenState();
}

class _SeasonScreenState extends State<SeasonScreen> with Utility {
  final serchController = TextEditingController();
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
                text: "Manage Season",
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              heightBox15(),
              Row(
                children: [
                  Expanded(
                      child: TextFormFieldWidget(
                    controller: serchController,
                    isSuffixIconShow: true,
                    onChanged: (p0) {
                      context.read<GetAllSeasonCubit>().getAllSeason(
                            search: p0,
                          );
                    },
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
                          builder: (context) => const SeasonAddUpdateScreen(),
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
              heightBox20(),
              BlocConsumer<DeleteSeasonCubit, DeleteSeasonState>(
                listener: (context, state) {
                  if (state is DeleteSeasonErrorState) {
                    Fluttertoast.showToast(msg: state.error);
                    return;
                  }

                  if (state is DeleteSeasonLoadedState) {
                    Fluttertoast.showToast(msg: "Delete Successfully ✅");
                    Navigator.pop(context);
                    context.read<GetAllSeasonCubit>().getAllSeason();
                  }
                },
                builder: (context, state) {
                  return BlocBuilder<GetAllSeasonCubit, GetAllSeasonState>(
                    builder: (context, state) {
                      if (state is GetAllSeasonLoadingState) {
                        return const Center(
                          child: CustomCircularProgressIndicator(),
                        );
                      }

                      if (state is GetAllSeasonErrorState) {
                        return const CustomErrorWidget();
                      }

                      if (state is GetAllSeasonLoadedState) {
                        return state.model.data?.isEmpty ?? true
                            ? const CustomEmptyWidget()
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final data = state.model.data?[index];
                                  return Card(
                                    color: AppColors.whiteColor,
                                    surfaceTintColor: AppColors.whiteColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                heightBox10(),
                                                TextWidget(
                                                  text: "${data?.series?.seriesName}",
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                const SizedBox(height: 4),
                                                TextWidget(
                                                  text: "${data?.seasonName}",
                                                  color: AppColors.greyColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => SeasonAddUpdateScreen(
                                                          id: data?.id,
                                                          data: data,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: svgAsset(assetName: AppImages.editSvg, height: 30)),
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
                                                                .read<DeleteSeasonCubit>()
                                                                .deleteSeason(data?.id ?? "");
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: svgAsset(assetName: AppImages.deleteSvg, height: 30)),
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
                  );
                },
              ),
              heightBox15(),
              BlocBuilder<GetAllSeasonCubit, GetAllSeasonState>(
                builder: (context, state) {
                  if (state is GetAllSeasonLoadedState) {
                    return CustomPagination(
                        currentPage: currentPage,
                        totalPages: state.model.pagination?.totalPages ?? 0,
                        onPageChanged: (e) {
                          setState(() {
                            currentPage = e;
                          });
                          context.read<GetAllSeasonCubit>().getAllSeason(
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
