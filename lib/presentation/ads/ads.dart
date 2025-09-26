import 'package:elite_admin/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite_admin/bloc/ads/delete_ads/delete_ads_cubit.dart';
import 'package:elite_admin/bloc/ads/get_all_ads/get_all_ads_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/presentation/ads/add_update_ads.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_empty_widget.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/delete_dialog.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> with Utility {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: ListView(
          children: [
            const TextWidget(
              text: "Manage Ads",
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            heightBox15(),
            Row(
              children: [
                Expanded(
                    child: TextFormFieldWidget(
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
                        builder: (context) => const AdsAddUpdateScreen(),
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
            BlocListener<DeleteAdsCubit, DeleteAdsState>(
              listener: (context, state) {
                if (state is DeleteAdsErrorState) {
                 showMessage(context, state.error);
                  return;
                }

                if (state is DeleteAdsLaodedState) {
                 showMessage(context, "Delete Succesfully");
                  Navigator.pop(context);
                  context.read<GetAllAdsCubit>().getAllAds();
                }
              },
              child: BlocBuilder<GetAllAdsCubit, GetAllAdsState>(
                builder: (context, state) {
                  if (state is GetAllAdsLoadingState) {
                    return const Center(
                      child: CustomCircularProgressIndicator(),
                    );
                  }

                  if (state is GetAllAdsErrorState) {
                    return const Center(
                      child: CustomErrorWidget(),
                    );
                  }
                  if (state is GetAllAdsLaodedState) {
                    return state.model.data?.isEmpty ?? true
                        ? const Center(
                            child: CustomEmptyWidget(),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var data = state.model.data?[index];
                              return Card(
                                color: AppColors.whiteColor,
                                surfaceTintColor: AppColors.whiteColor,
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: "ID : ${data?.id?.substring(0, 5)}",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      TextWidget(
                                        text: "TITLE : ${data?.title ?? ""}",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      data?.adVideo == null
                                          ? const TextWidget(
                                              text: "NO VIDEO UPLOAD",
                                            )
                                          : const TextWidget(
                                              text: "VIDEO UPLOADED",
                                              color: AppColors.zGreenColor,
                                            ),
                                      TextWidget(
                                        text: "SKIP TIME :${data?.skipTime}",
                                      ),
                                      TextWidget(
                                        text: "ADS TIME :${data?.videoTime}",
                                      ),
                                    ],
                                  ),
                                  trailing: Wrap(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AdsAddUpdateScreen(
                                                data: data,
                                                id: data?.id,
                                              ),
                                            ),
                                          );
                                        },
                                        child: svgAsset(
                                          assetName: AppImages.editSvg,
                                          height: 32,
                                          width: 30,
                                        ),
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
                                                  context.read<DeleteAdsCubit>().deleteAds(data?.id ?? "");
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: svgAsset(
                                          assetName: AppImages.deleteSvg,
                                          height: 32,
                                          width: 28,
                                        ),
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
            )
          ],
        ),
      ),
    );
  }
}
