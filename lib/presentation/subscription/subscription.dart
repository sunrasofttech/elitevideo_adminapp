import 'package:elite_admin/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elite_admin/bloc/subscription/delete_subscription/delete_subscription_cubit.dart';
import 'package:elite_admin/bloc/subscription/get_subscription/get_subscription_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/presentation/subscription/add_update_subscription.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_empty_widget.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

import '../../utils/widget/delete_dialog.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> with Utility {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextWidget(
                text: "Subscription",
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              heightBox10(),
              Row(
                children: [
                  Expanded(
                      child: TextFormFieldWidget(
                    isSuffixIconShow: true,
                    hintText: "search subscription",
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
                          builder: (context) => const AddUpdateSubscriptionScreen(),
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
              heightBox15(),
              BlocListener<DeleteSubscriptionCubit, DeleteSubscriptionState>(
                listener: (context, state) {
                  if (state is DeleteSubscriptionErrorState) {
                   showMessage(context,  state.error);
                    return;
                  }

                  if (state is DeleteSubscriptionLoadedState) {
                   showMessage(context,  "Delete Successfully");
                    context.read<GetSubscriptionCubit>().getAllSub();
                    Navigator.pop(context);
                  }
                },
                child: BlocBuilder<GetSubscriptionCubit, GetSubscriptionState>(
                  builder: (context, state) {
                    if (state is GetSubscriptionLoadingState) {
                      return const Center(
                        child: CustomCircularProgressIndicator(),
                      );
                    }

                    if (state is GetSubscriptionErrorState) {
                      return const CustomErrorWidget();
                    }
                    if (state is GetSubscriptionLoadedState) {
                      return state.model.data?.isEmpty ?? false
                          ? const CustomEmptyWidget()
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var data = state.model.data?[index];
                                return Card(
                                    color: AppColors.whiteColor,
                                    surfaceTintColor: AppColors.whiteColor,
                                    child: Container(
                                      height: 130,
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                TextWidget(
                                                    text: 'Plan Name :${data?.planName}',
                                                    style: const TextStyle(fontSize: 16)),
                                                heightBox5(),
                                                TextWidget(text: 'Amount : ${data?.amount}'),
                                                heightBox5(),
                                                TextWidget(text: 'Duration : ${data?.timeDuration}'),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => AddUpdateSubscriptionScreen(
                                                        data: data,
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
                                              heightBox5(),
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
                                                              .read<DeleteSubscriptionCubit>()
                                                              .deleteSubscription(data?.id ?? "");
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
                                          )
                                        ],
                                      ),
                                    ));
                              },
                              itemCount: state.model.data?.length,
                            );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
