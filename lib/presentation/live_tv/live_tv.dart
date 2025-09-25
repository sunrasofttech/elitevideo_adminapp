import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:elite_admin/bloc/livetv/category/get_live_category/get_live_category_cubit.dart';
import 'package:elite_admin/bloc/livetv/create/delete_live_tv/delete_live_tv_cubit.dart';
import 'package:elite_admin/bloc/livetv/create/get_live_tv/get_live_tv_cubit.dart';
import 'package:elite_admin/bloc/livetv/create/update_live_tv/update_live_tv_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/presentation/live_tv/add_update_live_tv.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_empty_widget.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/custom_pagination.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/delete_dialog.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

import '../../utils/widget/custom_dropdown.dart';

class LiveTvScreen extends StatefulWidget {
  const LiveTvScreen({super.key});

  @override
  State<LiveTvScreen> createState() => _LiveTvScreenState();
}

class _LiveTvScreenState extends State<LiveTvScreen> with Utility {
  String? selectedLanguage;
  String? selectedLanguageId;
  int currentPage = 1;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<GetLiveTvCubit>().getAllLiveCategory();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: ListView(
            children: [
              const TextWidget(
                text: "Manage Live Tv",
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
                      context.read<GetLiveTvCubit>().getAllLiveCategory(
                            search: p0,
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
                          builder: (context) => const AddUpdateLiveTvScreen(),
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
                    child: BlocBuilder<GetLiveCategoryCubit, GetLiveCategoryState>(
                      builder: (context, state) {
                        if (state is GetLiveCategoryLoadedState) {
                          final languageNames =
                              state.model.data?.categories?.map((datum) => datum.name).whereType<String>().toList() ??
                                  [];
                          return CustomDropdown(
                            items: languageNames,
                            hinttext: "select Live Category",
                            selectedValue: selectedLanguage,
                            onChanged: (value) {
                              setState(() {
                                selectedLanguage = value;
                                final selectedDatum =
                                    state.model.data?.categories?.firstWhere((datum) => datum.name == value);
                                print("Selected Datum ID: ${selectedDatum?.id}");
                                selectedLanguageId = selectedDatum?.id;
                                context.read<GetLiveTvCubit>().getAllLiveCategory(
                                      liveCatId: selectedDatum?.id ?? "",
                                      page: 1,
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
              heightBox20(),
              BlocListener<UpdateLiveTvCubit, UpdateLiveTvState>(
                listener: (context, state) {
                  if (state is UpdateLiveTvErrorState) {
                    Fluttertoast.showToast(msg: state.error);
                    return;
                  }

                  if (state is UpdateLiveTvLoadedState) {
                    Fluttertoast.showToast(msg: "Update Movie Successfully");
                    context.read<GetLiveTvCubit>().getAllLiveCategory();
                  }
                },
                child: BlocListener<DeleteLiveTvCubit, DeleteLiveTvState>(
                  listener: (context, state) {
                    if (state is DeleteLiveTvErrorState) {
                      Fluttertoast.showToast(msg: state.error);
                      return;
                    }

                    if (state is DeleteLiveTvLoadedState) {
                      Fluttertoast.showToast(msg: "Delete Successfully");
                      context.read<GetLiveTvCubit>().getAllLiveCategory();
                      Navigator.pop(context);
                    }
                  },
                  child: BlocBuilder<GetLiveTvCubit, GetLiveTvState>(
                    builder: (context, state) {
                      if (state is GetLiveTvLoadingState) {
                        return const Center(
                          child: CustomCircularProgressIndicator(),
                        );
                      }

                      if (state is GetLiveTvErrorState) {
                        return const Center(
                          child: CustomErrorWidget(),
                        );
                      }

                      if (state is GetLiveTvLoadedState) {
                        return state.model.data?.channels?.isEmpty ?? true
                            ? const CustomEmptyWidget()
                            : GridView.builder(
                                itemCount: state.model.data?.channels?.length,
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
                                  final item = state.model.data?.channels?[index];
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
                                                    value: false,
                                                    onChanged: (value) {},
                                                  ),
                                                ),
                                                const Spacer(),
                                                Switch(
                                                  trackOutlineColor: const WidgetStatePropertyAll(AppColors.whiteColor),
                                                  activeColor: Colors.transparent,
                                                  thumbColor: const WidgetStatePropertyAll(AppColors.zGreenColor),
                                                  value: item?.status ?? false,
                                                  onChanged: (value) {
                                                    context.read<UpdateLiveTvCubit>().updateLiveTV(
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
                                                  text: "${item?.name}",
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
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => AddUpdateLiveTvScreen(
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
                                                                      .read<DeleteLiveTvCubit>()
                                                                      .deleteLiveTv([item?.id ?? ""]);
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
              BlocBuilder<GetLiveTvCubit, GetLiveTvState>(
                builder: (context, state) {
                  if (state is GetLiveTvLoadedState) {
                    return CustomPagination(
                        currentPage: currentPage,
                        totalPages: state.model.data?.totalPages ?? 0,
                        onPageChanged: (e) {
                          setState(() {
                            currentPage = e;
                          });
                          context.read<GetLiveTvCubit>().getAllLiveCategory(
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
