import 'package:elite_admin/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elite_admin/bloc/auth/delete_admin/delete_admin_cubit.dart';
import 'package:elite_admin/bloc/subadmin/get_subadmin/get_subadmin_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/presentation/subadmin/add_update_subadmin.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_empty_widget.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/delete_dialog.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class SubAdminScreen extends StatefulWidget {
  const SubAdminScreen({super.key});

  @override
  State<SubAdminScreen> createState() => _SubAdminScreenState();
}

class _SubAdminScreenState extends State<SubAdminScreen> with Utility {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextWidget(
              text: "Sub Admin",
              color: AppColors.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            heightBox15(),
            Row(
              children: [
                Expanded(
                  child: TextFormFieldWidget(
                    backgroundColor: AppColors.whiteColor,
                    hintText: "Search ...",
                    isSuffixIconShow: true,
                    suffixIcon: const Icon(Icons.search),
                  ),
                ),
                widthBox10(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddUpdateSubAdminScreen(),
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
            Padding(
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
                      child: BlocListener<DeleteAdminCubit, DeleteAdminState>(
                        listener: (context, state) {
                          if (state is DeleteAdminErrorState) {
                           showMessage(context,  state.error);
                            return;
                          }

                          if (state is DeleteAdminLoadedState) {
                           showMessage(context,  "Delete Sucessfully");
                            context.read<GetSubadminCubit>().getSubAdmins();
                          }
                        },
                        child: BlocBuilder<GetSubadminCubit, GetSubadminState>(
                          builder: (context, state) {
                            if (state is GetSubadminLoadingState) {
                              return const Center(
                                child: CustomCircularProgressIndicator(),
                              );
                            }
                            if (state is GetSubadminErrorState) {
                              return Center(
                                child: CustomErrorWidget(
                                  error: state.error,
                                ),
                              );
                            }
                            if (state is GetSubadminLaodedState) {
                              return state.model.data?.isEmpty ?? true
                                  ? const CustomEmptyWidget()
                                  : DataTable(
                                      headingRowColor: const WidgetStatePropertyAll(Colors.black),
                                      dataRowColor: const WidgetStatePropertyAll(AppColors.whiteColor),
                                      headingTextStyle: const TextStyle(color: Colors.white),
                                      columns: const [
                                        DataColumn(label: Text('Name')),
                                        DataColumn(label: Text('Pasword')),
                                        DataColumn(label: Text('Dashboard')),
                                        DataColumn(label: Text('Movies')),
                                        DataColumn(label: Text('Songs')),
                                        DataColumn(label: Text('Web Series')),
                                        DataColumn(label: Text('Tv Shows')),
                                        DataColumn(label: Text('Live TV')),
                                        DataColumn(label: Text('Short Film')),
                                        DataColumn(label: Text('Ads')),
                                        DataColumn(label: Text('Rentals')),
                                        DataColumn(label: Text('Language')),
                                        DataColumn(label: Text('Genre')),
                                        DataColumn(label: Text('SubAdmins')),
                                        DataColumn(label: Text('Subscription')),
                                        DataColumn(label: Text('Report')),
                                        DataColumn(label: Text('Notification')),
                                        DataColumn(label: Text('Settings')),
                                        DataColumn(label: Text('Status')),
                                        DataColumn(label: Text('Action')),
                                      ],
                                      rows: state.model.data?.map((e) {
                                            return DataRow(cells: [
                                              DataCell(Text(e.name ?? '')),
                                              DataCell(Text(e.password?.substring(0, 10) ?? '')),
                                              DataCell(
                                                Switch(
                                                  activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                  thumbColor: const WidgetStatePropertyAll(
                                                    Color.fromRGBO(65, 160, 255, 1),
                                                  ),
                                                  value: e.permissions?['Dashboard'] ?? false,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                              DataCell(
                                                Switch(
                                                  activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                  thumbColor: const WidgetStatePropertyAll(
                                                    Color.fromRGBO(65, 160, 255, 1),
                                                  ),
                                                  value: e.permissions?['Movie'] ?? false,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                              DataCell(
                                                Switch(
                                                  activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                  thumbColor: const WidgetStatePropertyAll(
                                                    Color.fromRGBO(65, 160, 255, 1),
                                                  ),
                                                  value: e.permissions?['Music'] ?? false,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                              DataCell(
                                                Switch(
                                                  activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                  thumbColor: const WidgetStatePropertyAll(
                                                    Color.fromRGBO(65, 160, 255, 1),
                                                  ),
                                                  value: e.permissions?['Web Series'] ?? false,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                              DataCell(
                                                Switch(
                                                  activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                  thumbColor: const WidgetStatePropertyAll(
                                                    Color.fromRGBO(65, 160, 255, 1),
                                                  ),
                                                  value: e.permissions?['Tv Show'] ?? false,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                              DataCell(
                                                Switch(
                                                  activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                  thumbColor: const WidgetStatePropertyAll(
                                                    Color.fromRGBO(65, 160, 255, 1),
                                                  ),
                                                  value: e.permissions?['Live TV'] ?? false,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                              DataCell(
                                                Switch(
                                                  activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                  thumbColor: const WidgetStatePropertyAll(
                                                    Color.fromRGBO(65, 160, 255, 1),
                                                  ),
                                                  value: e.permissions?['Short Film'] ?? false,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                              DataCell(
                                                Switch(
                                                  activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                  thumbColor: const WidgetStatePropertyAll(
                                                    Color.fromRGBO(65, 160, 255, 1),
                                                  ),
                                                  value: e.permissions?['Ads'] ?? false,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                              DataCell(
                                                Switch(
                                                  activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                  thumbColor: const WidgetStatePropertyAll(
                                                    Color.fromRGBO(65, 160, 255, 1),
                                                  ),
                                                  value: e.permissions?['Rentals'] ?? false,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                              DataCell(
                                                Switch(
                                                  activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                  thumbColor: const WidgetStatePropertyAll(
                                                    Color.fromRGBO(65, 160, 255, 1),
                                                  ),
                                                  value: e.permissions?['Reports'] ?? false,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                              DataCell(
                                                Switch(
                                                  activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                  thumbColor: const WidgetStatePropertyAll(
                                                    Color.fromRGBO(65, 160, 255, 1),
                                                  ),
                                                  value: e.permissions?['Language'] ?? false,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                              DataCell(
                                                Switch(
                                                  activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                  thumbColor: const WidgetStatePropertyAll(
                                                    Color.fromRGBO(65, 160, 255, 1),
                                                  ),
                                                  value: e.permissions?['Genre'] ?? false,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                              DataCell(
                                                Switch(
                                                  activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                  thumbColor: const WidgetStatePropertyAll(
                                                    Color.fromRGBO(65, 160, 255, 1),
                                                  ),
                                                  value: e.permissions?['Sub Admin'] ?? false,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                              DataCell(
                                                Switch(
                                                  activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                  thumbColor: const WidgetStatePropertyAll(
                                                    Color.fromRGBO(65, 160, 255, 1),
                                                  ),
                                                  value: e.permissions?['Subscription'] ?? false,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                              DataCell(
                                                Switch(
                                                  activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                  thumbColor: const WidgetStatePropertyAll(
                                                    Color.fromRGBO(65, 160, 255, 1),
                                                  ),
                                                  value: e.permissions?['Reports'] ?? false,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                              DataCell(
                                                Switch(
                                                  activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                  thumbColor: const WidgetStatePropertyAll(
                                                    Color.fromRGBO(65, 160, 255, 1),
                                                  ),
                                                  value: e.permissions?['Notification'] ?? false,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                              DataCell(
                                                Switch(
                                                  activeColor: const Color.fromRGBO(208, 249, 254, 1),
                                                  thumbColor: const WidgetStatePropertyAll(
                                                    Color.fromRGBO(65, 160, 255, 1),
                                                  ),
                                                  value: e.permissions?['Settings'] ?? false,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                              DataCell(Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => AddUpdateSubAdminScreen(
                                                            id: e.id ?? "",
                                                            e: e,
                                                          ),
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
                                                              context.read<DeleteAdminCubit>().deleteUser(e.id ?? "");
                                                              Navigator.pop(context);
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: svgAsset(assetName: AppImages.deleteSvg),
                                                  ),
                                                ],
                                              )),
                                            ]);
                                          }).toList() ??
                                          [],
                                    );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
