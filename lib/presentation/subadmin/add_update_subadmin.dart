import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:elite_admin/bloc/auth/update_profile/update_profile_cubit.dart';
import 'package:elite_admin/bloc/subadmin/create_subadmin/create_subadmin_cubit.dart';
import 'package:elite_admin/bloc/subadmin/get_subadmin/get_subadmin_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

import '../../bloc/subadmin/get_subadmin/get_subadmin_model.dart';

class AddUpdateSubAdminScreen extends StatefulWidget {
  const AddUpdateSubAdminScreen({super.key, this.id, this.e});
  final String? id;
  final Datum? e;

  @override
  State<AddUpdateSubAdminScreen> createState() => _AddUpdateSubAdminScreenState();
}

class _AddUpdateSubAdminScreenState extends State<AddUpdateSubAdminScreen> with Utility {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Map<String, bool> selectedPermissions = {for (var permission in Utility.subAdminPermission) permission: false};

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileNoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.e != null) {
      nameController.text = widget.e?.name ?? '';
      emailController.text = widget.e?.email ?? '';

      widget.e!.permissions?.forEach((key, value) {
        if (selectedPermissions.containsKey(key)) {
          selectedPermissions[key] = value;
        }
      });
    }
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
                text: widget.id != null ? "Edit Sub Admin" : "Add Sub Admin",
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
                      text: "Password",
                      fontSize: 14,
                    ),
                    heightBox10(),
                    TextFormFieldWidget(
                      controller: passwordController,
                    ),
                    heightBox15(),
                    const TextWidget(text: "Select Permissions", fontSize: 14),
                    heightBox10(),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: selectedPermissions.keys.map((key) {
                        return FilterChip(
                          label: Text(key),
                          selected: selectedPermissions[key]!,
                          onSelected: (val) {
                            setState(() {
                              selectedPermissions[key] = val;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    heightBox15(),
                    BlocConsumer<CreateSubadminCubit, CreateSubadminState>(
                      listener: (context, state) {
                        if (state is CreateSubadminErrorState) {
                          Fluttertoast.showToast(msg: state.erorr);
                          return;
                        }

                        if (state is CreateSubadminLoadedState) {
                          Fluttertoast.showToast(msg: "Sub Admin Created Successfully");
                          Navigator.pop(context);
                          context.read<GetSubadminCubit>().getSubAdmins();
                        }
                      },
                      builder: (context, state) {
                        return BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
                          listener: (context, state) {
                            if (state is UpdateProfileErrorState) {
                              Fluttertoast.showToast(msg: state.error);
                            }
                            if (state is UpdateProfileLoadedState) {
                              Fluttertoast.showToast(msg: "Update Sucessfully");
                              context.read<GetSubadminCubit>().getSubAdmins();
                              Navigator.pop(context);
                            }
                          },
                          builder: (context, updateState) {
                            return CustomOutlinedButton(
                              inProgress:
                                  (state is CreateSubadminLoadingState || updateState is UpdateProfileLoadingState),
                              onPressed: () {
                                if (widget.id != null) {
                                  context.read<UpdateProfileCubit>().updateProfile(
                                        userId: widget.id ?? "",
                                        name: nameController.text,
                                        password: passwordController.text,
                                        selectedPermissions: selectedPermissions.entries
                                            .where((entry) => entry.value)
                                            .map((entry) => MapEntry(entry.key, true))
                                            .map((entry) => Map<String, dynamic>.from({entry.key: entry.value}))
                                            .reduce((a, b) => {...a, ...b}),
                                      );
                                  return;
                                }

                                context.read<CreateSubadminCubit>().createSubAdmin(
                                      name: nameController.text,
                                      password: passwordController.text,
                                      selectedPermissions: selectedPermissions.entries
                                          .where((entry) => entry.value)
                                          .map((entry) => MapEntry(entry.key, true))
                                          .map((entry) => Map<String, dynamic>.from({entry.key: entry.value}))
                                          .reduce((a, b) => {...a, ...b}),
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
              backButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
