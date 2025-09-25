import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:elite_admin/bloc/users/get_all_user/get_all_user_cubit.dart';
import 'package:elite_admin/bloc/users/get_all_user/get_all_user_model.dart';
import 'package:elite_admin/bloc/users/post_user/post_user_cubit.dart';
import 'package:elite_admin/bloc/users/update_user/update_user_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_back_button.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class AddUpdateUserScreen extends StatefulWidget {
  const AddUpdateUserScreen({super.key, this.id, this.user});
  final String? id;
  final User? user;

  @override
  State<AddUpdateUserScreen> createState() => _AddUpdateUserScreenState();
}

class _AddUpdateUserScreenState extends State<AddUpdateUserScreen> with Utility {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      nameController.text = widget.user?.name ?? '';
      emailController.text = widget.user?.email ?? "";
      mobileNoController.text = widget.user?.mobileNo ?? "";
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileNoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heightBox20(),
              TextWidget(
                text: widget.id != null ? "Edit User" : "Add User",
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              heightBox15(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextWidget(
                      text: "Name",
                      fontSize: 14,
                    ),
                    heightBox10(),
                    TextFormFieldWidget(
                      controller: nameController,
                    ),
                    heightBox15(),
                    const TextWidget(
                      text: "Email",
                      fontSize: 14,
                    ),
                    heightBox10(),
                    TextFormFieldWidget(
                      controller: emailController,
                    ),
                    heightBox15(),
                    const TextWidget(
                      text: "Mobile",
                      fontSize: 14,
                    ),
                    heightBox10(),
                    TextFormFieldWidget(
                      controller: mobileNoController,
                      inputFormater: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    heightBox15(),
                    const TextWidget(
                      text: "Password",
                      fontSize: 14,
                    ),
                    heightBox10(),
                    TextFormFieldWidget(
                      controller: passwordController,
                    ),
                    heightBox15(),
                    BlocConsumer<UpdateUserCubit, UpdateUserState>(
                      listener: (context, state) {
                        if (state is UpdateUserLoadedState) {
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: "Update Successfully");
                          context.read<GetAllUserCubit>().getAllUser();
                        }

                        if (state is UpdateUserErrorState) {
                          Fluttertoast.showToast(msg: state.error);
                          return;
                        }
                      },
                      builder: (context, state) {
                        return BlocConsumer<PostUserCubit, PostUserState>(
                          listener: (context, state) {
                            if (state is PostUserLoadedState) {
                              Navigator.pop(context);
                              Fluttertoast.showToast(msg: "Post Successfully");
                              context.read<GetAllUserCubit>().getAllUser();
                            }

                            if (state is PostUserErrorState) {
                              Fluttertoast.showToast(msg: state.error);
                              return;
                            }
                          },
                          builder: (context, postState) {
                            return CustomOutlinedButton(
                              inProgress: (postState is PostUserLoadingState || state is UpdateUserLoadingState),
                              onPressed: () {
                                if (widget.id != null) {
                                  context.read<UpdateUserCubit>().updateUser(
                                        id: widget.id,
                                        email: emailController.text,
                                        mobileNo: mobileNoController.text,
                                        name: nameController.text,
                                        password: passwordController.text,
                                      );
                                  return;
                                }

                                context.read<PostUserCubit>().postUser(
                                      email: emailController.text,
                                      mobileNo: mobileNoController.text,
                                      name: nameController.text,
                                      password: passwordController.text,
                                    );
                              },
                              buttonText: widget.id != null ? 'Save' : 'Add',
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              heightBox20(),
              CustomBackButton(
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
