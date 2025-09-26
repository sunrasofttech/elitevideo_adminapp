import 'package:elite_admin/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite_admin/bloc/users/delete_user/delete_user_cubit.dart';
import 'package:elite_admin/bloc/users/get_all_user/get_all_user_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/presentation/users/add_update_user.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_empty_widget.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/custom_pagination.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/delete_dialog.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with Utility {
  final searchController = TextEditingController();
  int currentPage = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextWidget(text: "User", color: AppColors.blackColor, fontSize: 16, fontWeight: FontWeight.w500),
            heightBox15(),
            Row(
              children: [
                Expanded(
                  child: TextFormFieldWidget(
                    controller: searchController,
                    backgroundColor: AppColors.whiteColor,
                    onChanged: (value) {
                      final input = value.trim();
                      if (input.isEmpty) return;
                      if (RegExp(r'^\d+$').hasMatch(input)) {
                        context.read<GetAllUserCubit>().getAllUser(mobileNo: input, name: null);
                      } else {
                        context.read<GetAllUserCubit>().getAllUser(name: input, mobileNo: null);
                      }
                    },
                    hintText: "search user...",
                    isSuffixIconShow: true,
                    suffixIcon: const Icon(Icons.search),
                  ),
                ),
                widthBox10(),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddUpdateUserScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      gradient: LinearGradient(colors: AppColors.blueGradientList),
                    ),
                    child: Row(
                      children: [
                        const TextWidget(text: "Add", color: AppColors.whiteColor),
                        widthBox5(),
                        const Icon(Icons.add_circle_rounded, color: AppColors.whiteColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            heightBox15(),
            BlocListener<DeleteUserCubit, DeleteUserState>(
              listener: (context, state) {
                if (state is DeleteUserErrorState) {
                  showMessage(context, state.error);
                  return;
                }
                if (state is DeleteUserLoadedState) {
                  showMessage(context, "Delete Sucessfully");
                  Navigator.pop(context);
                  context.read<GetAllUserCubit>().getAllUser();
                }
              },
              child: BlocBuilder<GetAllUserCubit, GetAllUserState>(
                builder: (context, state) {
                  if (state is GetAllUserLoadingState) {
                    return const Center(child: CustomCircularProgressIndicator());
                  }

                  if (state is GetAllUserErrorState) {
                    return const CustomErrorWidget();
                  }

                  if (state is GetAllUserLoadedState) {
                    return state.model.users?.isEmpty ?? true
                        ? const CustomEmptyWidget()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            child: SingleChildScrollView(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: DataTable(
                                      headingRowColor: const WidgetStatePropertyAll(Colors.black),
                                      dataRowColor: const WidgetStatePropertyAll(AppColors.whiteColor),
                                      headingTextStyle: const TextStyle(color: Colors.white),
                                      columns: const [
                                        DataColumn(label: Text('Name')),
                                        DataColumn(label: Text('Email')),
                                        DataColumn(label: Text('Mobile')),
                                        DataColumn(label: Text('Register on')),
                                        DataColumn(label: Text('Membership Type')),
                                        DataColumn(label: Text('Status')),
                                        DataColumn(label: Text('Action')),
                                      ],
                                      rows:
                                          state.model.users?.map((e) {
                                            return DataRow(
                                              cells: [
                                                DataCell(Text(e.name ?? '')),
                                                DataCell(Text(e.email ?? '')),
                                                DataCell(Text(e.mobileNo ?? '')),
                                                DataCell(Text(e.createdAt.toString())),
                                                DataCell(Text(e.isPaidMember.toString())),
                                                DataCell(
                                                  Switch(
                                                    activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                    thumbColor: const WidgetStatePropertyAll(
                                                      Color.fromRGBO(65, 160, 255, 1),
                                                    ),
                                                    value: e.isBlock ?? false,
                                                    onChanged: (value) {},
                                                  ),
                                                ),
                                                DataCell(
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AddUpdateUserScreen(id: e.id ?? "", user: e),
                                                            ),
                                                          );
                                                        },
                                                        child: svgAsset(assetName: AppImages.editSvg),
                                                      ),
                                                      widthBox10(),
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
                                                                  context.read<DeleteUserCubit>().deleteUser(
                                                                    e.id ?? "",
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: svgAsset(assetName: AppImages.deleteSvg),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList() ??
                                          [],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                  }
                  return const SizedBox();
                },
              ),
            ),
            heightBox15(),
            BlocBuilder<GetAllUserCubit, GetAllUserState>(
              builder: (context, state) {
                if (state is GetAllUserLoadedState) {
                  return CustomPagination(
                    currentPage: currentPage,
                    totalPages: state.model.pages ?? 0,
                    onPageChanged: (e) {
                      setState(() {
                        currentPage = e;
                      });
                      context.read<GetAllUserCubit>().getAllUser(page: currentPage);
                    },
                  );
                }
                return const SizedBox();
              },
            ),
            heightBox15(),
          ],
        ),
      ),
    );
  }
}
