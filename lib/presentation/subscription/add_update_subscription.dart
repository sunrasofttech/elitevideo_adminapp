import 'package:elite_admin/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elite_admin/bloc/subscription/create_subscription/create_subscription_cubit.dart';
import 'package:elite_admin/bloc/subscription/get_subscription/get_subscription_cubit.dart';
import 'package:elite_admin/bloc/subscription/get_subscription/get_subscription_model.dart';
import 'package:elite_admin/bloc/subscription/update_subscription/update_subscription_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_dropdown.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class AddUpdateSubscriptionScreen extends StatefulWidget {
  const AddUpdateSubscriptionScreen({super.key, this.data});
  final Datum? data;

  @override
  State<AddUpdateSubscriptionScreen> createState() => _AddUpdateSubscriptionScreenState();
}

class _AddUpdateSubscriptionScreenState extends State<AddUpdateSubscriptionScreen> with Utility {
  final planNameController = TextEditingController();
  final planPriceController = TextEditingController();
  final numberOfAccountLoggedCountController = TextEditingController();
  bool status = true;
  bool watchonTvLaptop = false;
  bool addFreeMovie = false;
  bool allContent = false;
  final List<String> _durations = ['Year', 'Month', 'Week'];
  String _selectedDuration = 'Month';

  @override
  void initState() {
    if (widget.data != null) {
      planNameController.text = widget.data?.planName ?? "";
      planPriceController.text = widget.data?.amount ?? "";
      numberOfAccountLoggedCountController.text = widget.data?.numberOfDeviceThatLogged.toString() ?? "";
      status = widget.data?.status ?? false;
      watchonTvLaptop = widget.data?.watchonTvLaptop ?? false;
      addFreeMovie = widget.data?.addfreeMovieShows ?? false;
      allContent = widget.data?.allContent ?? false;
      _selectedDuration = widget.data?.timeDuration ?? "";
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heightBox20(),
              heightBox10(),
              TextWidget(
                text: widget.data != null ? "Update Subscription" : "Add Subscription",
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              heightBox15(),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heightBox10(),
                    TextFormFieldWidget(
                      hintText: "Plan name",
                      controller: planNameController,
                    ),
                    heightBox15(),
                    TextFormFieldWidget(
                      hintText: "Plan Price",
                      keyboardType: TextInputType.number,
                      inputFormater: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: planPriceController,
                    ),
                    heightBox15(),
                    TextFormFieldWidget(
                      keyboardType: TextInputType.number,
                      inputFormater: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: numberOfAccountLoggedCountController,
                      hintText: "Number Of Account Logged Count",
                    ),
                    heightBox15(),
                    const TextWidget(
                      text: "Duration",
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                    heightBox10(),
                    CustomDropdown(
                      items: _durations,
                      selectedValue: _selectedDuration,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDuration = newValue!;
                        });
                      },
                    ),
                    heightBox15(),
                    const TextWidget(
                      text: "Ads Free",
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                    heightBox10(),
                    Switch(
                      activeColor: AppColors.zGreenColor,
                      value: addFreeMovie,
                      onChanged: (v) {
                        setState(() {
                          addFreeMovie = v;
                        });
                      },
                    ),
                    heightBox15(),
                    const TextWidget(
                      text: "Status",
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                    heightBox10(),
                    Switch(
                      activeColor: AppColors.zGreenColor,
                      value: status,
                      onChanged: (v) {
                        setState(() {
                          status = v;
                        });
                      },
                    ),
                    heightBox15(),
                    const TextWidget(
                      text: "All Content",
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                    heightBox10(),
                    Switch(
                      activeColor: AppColors.zGreenColor,
                      value: allContent,
                      onChanged: (v) {
                        setState(() {
                          allContent = v;
                        });
                      },
                    ),
                    heightBox15(),
                    const TextWidget(
                      text: "Watch TV/Laptop",
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                    heightBox10(),
                    Switch(
                      activeColor: AppColors.zGreenColor,
                      value: watchonTvLaptop,
                      onChanged: (v) {
                        setState(() {
                          watchonTvLaptop = v;
                        });
                      },
                    ),
                    heightBox15(),
                    BlocConsumer<CreateSubscriptionCubit, CreateSubscriptionState>(
                      listener: (context, state) {
                        if (state is CreateSubscriptionErrorState) {
                         showMessage(context,  state.error);
                          return;
                        }
                        if (state is CreateSubscriptionLoadedState) {
                         showMessage(context,  "Create Sucessfully");
                          Navigator.pop(context);
                          context.read<GetSubscriptionCubit>().getAllSub();
                        }
                      },
                      builder: (context, state) {
                        return BlocConsumer<UpdateSubscriptionCubit, UpdateSubscriptionState>(
                          listener: (context, state) {
                            if (state is UpdateSubscriptionErrorState) {
                             showMessage(context,  state.error);
                              return;
                            }

                            if (state is UpdateSubscriptionLoadedState) {
                             showMessage(context,  "Update Successfully");
                              Navigator.pop(context);
                              context.read<GetSubscriptionCubit>().getAllSub();
                            }
                          },
                          builder: (context, updateState) {
                            return CustomOutlinedButton(
                              inProgress: (updateState is UpdateSubscriptionLoadingState ||
                                  state is CreateSubscriptionLoadingState),
                              onPressed: () {
                                if (widget.data != null) {
                                  context.read<UpdateSubscriptionCubit>().uodateSubScription(
                                        id: widget.data?.id ?? "",
                                        addfreeMovieShows: addFreeMovie,
                                        allContent: allContent,
                                        amount: planPriceController.text,
                                        maxVideoQuality: "",
                                        numberOfDeviceThatLogged: numberOfAccountLoggedCountController.text,
                                        planName: planNameController.text,
                                        status: status,
                                        timeDuration: _selectedDuration,
                                        watchonTvLaptop: watchonTvLaptop,
                                      );
                                  return;
                                }

                                final planName = planNameController.text.trim();
                                final price = planPriceController.text.trim();

                                if (planName.isEmpty || price.isEmpty) {
                                 showMessage(context,  "Plan Name and Price are required.");
                                  return;
                                }

                                context.read<CreateSubscriptionCubit>().createSubScription(
                                      planName: planNameController.text,
                                      numberOfDeviceThatLogged: numberOfAccountLoggedCountController.text,
                                      amount: planPriceController.text,
                                      timeDuration: _selectedDuration,
                                      status: status,
                                      maxVideoQuality: "",
                                      allContent: allContent,
                                      watchonTvLaptop: watchonTvLaptop,
                                      addfreeMovieShows: addFreeMovie,
                                    );
                              },
                              buttonText: widget.data != null ? "Update Subscription" : "Add Subscription",
                            );
                          },
                        );
                      },
                    ),
                    heightBox15(),
                  ],
                ),
              ),
              heightBox15(),
              backButton(context),
              heightBox15(),
            ],
          ),
        ),
      ),
    );
  }
}
