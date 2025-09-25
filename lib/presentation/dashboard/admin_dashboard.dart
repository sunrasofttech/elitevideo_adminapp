import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:elite_admin/bloc/auth/get_profile/get_profile_cubit.dart';
import 'package:elite_admin/bloc/dashboard/get_dashboard/get_dashboard_cubit.dart';
import 'package:elite_admin/bloc/dashboard/get_revenue_analysis/get_revenue_anaylsis_cubit.dart';
import 'package:elite_admin/bloc/dashboard/get_user_analysis/get_user_analysis_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/presentation/auth/login_screen.dart';
import 'package:elite_admin/presentation/auth/profile.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:elite_admin/utils/preferences/local_preferences.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class AdminDashboardScreen extends StatelessWidget with Utility {
  const AdminDashboardScreen({super.key, required this.onMenuTap});
  final void Function() onMenuTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<GetProfileCubit, GetProfileState>(
        listener: (context, state) {
          if (state is GetProfileErrorState &&
              (state.error.contains("Session expired. Please login again") ||
                  state.error.contains("Invalid or expired token"))) {
            LocalStorageUtils.clear().then((e) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
            });
          }
        },
        builder: (context, state) {
          if (state is GetProfileLoadingState) {
            return const Center(
              //market place
              child: CustomCircularProgressIndicator(),
            );
          }

          if (state is GetProfileErrorState) {
            return const Center(
              child: CustomErrorWidget(),
            );
          }

          if (state is GetProfileLoadedState) {
            return Scaffold(
              body: SingleChildScrollView(
                child: BlocBuilder<GetDashboardCubit, GetDashboardState>(
                  builder: (context, dState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 300,
                              padding: const EdgeInsets.all(15),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(24),
                                  bottomRight: Radius.circular(24),
                                ),
                                gradient: LinearGradient(
                                  colors: AppColors.blueGradientList,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: onMenuTap,
                                        child: SvgPicture.asset(
                                          AppImages.drawerSvg,
                                          height: 27,
                                          width: 27,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          color: Color.fromRGBO(31, 30, 30, 0.2),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              AppImages.notificationSvg,
                                              color: AppColors.whiteColor,
                                            ),
                                            widthBox10(),
                                            PopupMenuButton<String>(
                                              onSelected: (value) async {
                                                if (value == 'profile') {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => const ProfileScreen(),
                                                    ),
                                                  );
                                                } else if (value == 'logout') {
                                                  await LocalStorageUtils.clear().then((e) => {
                                                        Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => const LoginScreen(),
                                                          ),
                                                          (route) => false,
                                                        )
                                                      });
                                                }
                                              },
                                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                                PopupMenuItem<String>(
                                                  value: 'profile',
                                                  child: Row(
                                                    children: [
                                                      state.model.admin?.profileImg != null
                                                          ? CircleAvatar(
                                                              backgroundImage: NetworkImage(
                                                                  "${AppUrls.baseUrl}/${state.model.admin?.profileImg}"))
                                                          : SvgPicture.asset(
                                                              "asset/svg/profile-circle.svg",
                                                              height: 25,
                                                              color: AppColors.blackColor,
                                                              width: 25,
                                                            ),
                                                      widthBox10(),
                                                      const TextWidget(text: 'Profile'),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem<String>(
                                                  value: 'logout',
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        "asset/svg/logout.svg",
                                                        height: 25,
                                                        color: AppColors.blackColor,
                                                        width: 25,
                                                      ),
                                                      widthBox10(),
                                                      const TextWidget(text: 'Logout'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundImage:
                                                    NetworkImage("${AppUrls.baseUrl}/${state.model.admin?.profileImg}"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  heightBox20(),
                                  const TextWidget(
                                    text: "Hii",
                                    color: AppColors.whiteColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  TextWidget(
                                    text: "${state.model.admin?.name}",
                                    color: AppColors.whiteColor,
                                    fontSize: 33,
                                    fontWeight: FontWeight.w700,
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                                bottom: -30,
                                right: 0,
                                left: 0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(18),
                                          decoration: BoxDecoration(
                                            color: AppColors.whiteColor,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset("asset/svg/total_user.svg"),
                                              heightBox5(),
                                              const TextWidget(
                                                text: "Total Users",
                                                fontSize: 14,
                                              ),
                                              heightBox5(),
                                              TextWidget(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                text: dState is GetDashboardLoadedState
                                                    ? "${dState.model.data?.totalUsers}"
                                                    : "0",
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      widthBox20(),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(18),
                                          decoration: BoxDecoration(
                                            color: AppColors.whiteColor,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset("asset/svg/subscrption.svg"),
                                              heightBox5(),
                                              const TextWidget(
                                                text: "Active Users",
                                                fontSize: 14,
                                              ),
                                              heightBox5(),
                                              TextWidget(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                text: dState is GetDashboardLoadedState
                                                    ? "${dState.model.data?.activeUsers}"
                                                    : "0",
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                        heightBox50(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextWidget(
                                text: "Quick Actions",
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                              heightBox15(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset("asset/svg/music.svg"),
                                              widthBox10(),
                                              TextWidget(
                                                text: dState is GetDashboardLoadedState
                                                    ? "${dState.model.data?.totalSongs}"
                                                    : "0",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ],
                                          ),
                                          heightBox10(),
                                          const TextWidget(
                                            text: "Songs",
                                            fontSize: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  widthBox20(),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset("asset/svg/movie.svg"),
                                              widthBox10(),
                                              TextWidget(
                                                text: dState is GetDashboardLoadedState
                                                    ? "${dState.model.data?.totalMovies}"
                                                    : "0",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ],
                                          ),
                                          heightBox10(),
                                          const TextWidget(
                                            text: "Movies",
                                            fontSize: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              heightBox15(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset("asset/svg/total_user.svg"),
                                              widthBox10(),
                                              TextWidget(
                                                text: dState is GetDashboardLoadedState
                                                    ? "${dState.model.data?.totalUsers}"
                                                    : "0",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ],
                                          ),
                                          heightBox10(),
                                          const TextWidget(
                                            text: "Users",
                                            fontSize: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  widthBox20(),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset("asset/svg/subscrption.svg"),
                                              widthBox10(),
                                              TextWidget(
                                                text: dState is GetDashboardLoadedState
                                                    ? "${dState.model.data?.subscriberActiveUsers}"
                                                    : "0",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ],
                                          ),
                                          heightBox10(),
                                          const TextWidget(
                                            text: "Subscriptions",
                                            fontSize: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              heightBox10(),
                              const TextWidget(
                                text: "Recent Activities",
                                color: AppColors.blackColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              heightBox10(),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 2,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                      child: const ListTile(
                                        leading: CircleAvatar(
                                          radius: 25,
                                        ),
                                        title: TextWidget(
                                          text: "John Doe purchased Premium Plan",
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.blackColor,
                                        ),
                                        subtitle: TextWidget(
                                          text: "5 hour ago",
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              heightBox15(),
                              const UserAnalysisChart(),
                              heightBox20(),
                              const RevenueChartCard(),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class UserAnalysisChart extends StatefulWidget {
  const UserAnalysisChart({super.key});

  @override
  State<UserAnalysisChart> createState() => _UserAnalysisChartState();
}

class _UserAnalysisChartState extends State<UserAnalysisChart> {
  String selectedYear = DateTime.now().year.toString();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserAnalysisCubit, GetUserAnalysisState>(
      builder: (context, state) {
        if (state is GetUserAnalysisLoadingState) {
          return const Center(
            child: CustomCircularProgressIndicator(),
          );
        }
        if (state is GetUserAnalysisLoadedState) {
          final userData = state.model.data;
          final spots = userData?.map((data) {
                return FlSpot(
                  (data.monthNumber! - 1).toDouble(),
                  data.userCount?.toDouble() ?? 0.0,
                );
              }).toList() ??
              [];

          double maxYValue = userData!.map((data) => data.userCount).reduce((a, b) => a! > b! ? a : b)! + 10;
          final yearList = ['2024', '2025', '2026', '2027', '2028', '2029', '2030'];

          return Card(
            surfaceTintColor: AppColors.whiteColor,
            color: AppColors.whiteColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("User Analysis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("New Registrations", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      DropdownButton<String>(
                        value: selectedYear,
                        items: yearList.map((year) {
                          return DropdownMenuItem(value: year, child: Text(year));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedYear = value!;
                          });
                          context.read<GetUserAnalysisCubit>().getUserAnalysis(year: value!);
                        },
                        underline: Container(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Chart
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, _) {
                                  const months = [
                                    'Jan',
                                    'Feb',
                                    'Mar',
                                    'Apr',
                                    'May',
                                    'Jun',
                                    'Jul',
                                    'Aug',
                                    'Sep',
                                    'Oct',
                                    'Nov',
                                    'Dec'
                                  ];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(months[value.toInt()], style: const TextStyle(fontSize: 12)),
                                  );
                                },
                                reservedSize: 30,
                                interval: 1,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, _) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(fontSize: 12, color: AppColors.blackColor),
                                  );
                                },
                                reservedSize: 40,
                              ),
                            ),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          minX: 0,
                          maxX: 11,
                          minY: 0,
                          maxY: maxYValue > 0 ? maxYValue : 10,
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              barWidth: 5,
                              color: Colors.green,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [Colors.green.withOpacity(0.4), Colors.green.withOpacity(0.05)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              spots: spots,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class RevenueChartCard extends StatefulWidget {
  const RevenueChartCard({super.key});

  @override
  State<RevenueChartCard> createState() => _RevenueChartCardState();

  static double _getMaxRevenue(List<dynamic> data) {
    if (data.isEmpty) return 10;
    final maxValue = data.map((e) => (e.totalRevenue ?? 0).toDouble()).reduce((a, b) => a > b ? a : b);
    return maxValue > 0 ? maxValue : 10;
  }
}

String selectedYear = DateTime.now().year.toString();

class _RevenueChartCardState extends State<RevenueChartCard> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetRevenueAnaylsisCubit, GetRevenueAnaylsisState>(
      builder: (context, state) {
        if (state is GetRevenueAnaylsisLoadingState) {
          return const Center(child: CustomCircularProgressIndicator());
        }

        if (state is GetRevenueAnaylsisLoadedState) {
          final revenueData = state.model.data ?? [];
          final yearList = ['2024', '2025', '2026', '2027', '2028', '2029', '2030'];
          return Card(
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Revenue", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Year ${revenueData.isNotEmpty ? revenueData.first.year : ''}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      DropdownButton<String>(
                        value: selectedYear,
                        items: yearList.map((year) {
                          return DropdownMenuItem(value: year, child: Text(year));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedYear = value!;
                          });
                          context.read<GetRevenueAnaylsisCubit>().getRevenueAnalysis(year: value!);
                        },
                        underline: Container(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: RevenueChartCard._getMaxRevenue(revenueData) + 5,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: (RevenueChartCard._getMaxRevenue(revenueData) / 5).ceilToDouble(),
                              getTitlesWidget: (value, _) {
                                return Text('${value.toInt()}', style: const TextStyle(fontSize: 12));
                              },
                              reservedSize: 40,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                if (value.toInt() >= 0 && value.toInt() < revenueData.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      revenueData[value.toInt()].month?.substring(0, 3) ?? "",
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: _buildRevenueBars(revenueData),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  List<BarChartGroupData> _buildRevenueBars(List<dynamic> revenueData) {
    return List.generate(revenueData.length, (index) {
      final value = (revenueData[index].totalRevenue ?? 0).toDouble();

      return BarChartGroupData(
        x: index,
        barRods: [
          // Background
          BarChartRodData(
            toY: RevenueChartCard._getMaxRevenue(revenueData),
            width: 14,
            color: Colors.grey.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          // Actual revenue
          BarChartRodData(
            toY: value,
            width: 20,
            color: AppColors.blueColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
        ],
      );
    });
  }
}
