import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite_admin/bloc/reports/get_reports/get_reports_cubit.dart';
import 'package:elite_admin/bloc/reports/get_reports/get_reports_model.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

import '../../constant/color.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> with Utility, SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightGreyColor,
        title: const TextWidget(
          text: "Manage Reports",
          fontWeight: FontWeight.w500,
          fontSize: 17,
        ),
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          indicatorColor: AppColors.blueColor,
          unselectedLabelColor: AppColors.greyColor,
          labelColor: AppColors.blueColor,
          tabs: const [
            Tab(text: "Movie Report"),
            Tab(text: "Short Film Report"),
            Tab(text: "Series Report"),
          ],
        ),
      ),
      body: BlocBuilder<GetReportsCubit, GetReportsState>(builder: (context, state) {
        if (state is GetReportsErrorState) {
          return const Center(
            child: CustomCircularProgressIndicator(),
          );
        }

        if (state is GetReportsErrorState) {
          return CustomErrorWidget(
            error: state.error,
          );
        }
        if (state is GetReportsLoadedState) {
          final movieReports = state.model.data?.where((e) => e.contentType == "movie").toList();

          final seriesReports = state.model.data?.where((e) => e.contentType == "series").toList();

          final shortFilmReports = state.model.data?.where((e) => e.contentType == "shortfilm").toList();
          return TabBarView(
            controller: _tabController,
            children: [
              _movieReport(movieReports),
              shortFilmReport(shortFilmReports),
              _seriesReport(seriesReports),
            ],
          );
        }
        return const SizedBox();
      }),
    );
  }
}

_seriesReport(List<ReportModel>? seriesReports) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
            DataColumn(label: Text('Series')),
            DataColumn(label: Text('Total Reports')),
          ],
          rows: seriesReports
                  ?.map((report) => DataRow(cells: [
                        DataCell(Text(report.contentDetails?.seriesName ?? "")),
                        DataCell(Text(report.reason ?? "")),
                      ]))
                  .toList() ??
              [],
        ),
      ),
    ),
  );
}

Widget _movieReport(List<ReportModel>? movieReports) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
            DataColumn(label: Text('Movie')),
            DataColumn(label: Text('Reason')),
          ],
          rows: movieReports
                  ?.map((report) => DataRow(cells: [
                        DataCell(Text(report.contentDetails?.movieName ?? "")),
                        DataCell(Text(report.reason ?? "")),
                      ]))
                  .toList() ??
              [],
        ),
      ),
    ),
  );
}

shortFilmReport(List<ReportModel>? shortFilmReports) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
            DataColumn(label: Text('Short Film')),
            DataColumn(label: Text('Total Reports')),
          ],
          rows: shortFilmReports
                  ?.map((report) => DataRow(cells: [
                        DataCell(Text(report.contentDetails?.shortFilmTitle ?? "")),
                        DataCell(Text(report.reason ?? "")),
                      ]))
                  .toList() ??
              [],
        ),
      ),
    ),
  );
}
