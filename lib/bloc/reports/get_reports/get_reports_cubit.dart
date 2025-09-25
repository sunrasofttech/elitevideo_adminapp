import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/bloc/reports/get_reports/get_reports_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'get_reports_state.dart';

class GetReportsCubit extends Cubit<GetReportsState> {
  GetReportsCubit() : super(GetReportsInitial());

  getReports() async {
    try {
      emit(GetReportsLoadingState());
      var response = await post(
        Uri.parse(AppUrls.getReportssUrl),
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetReportsLoadedState(
              getReportModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetReportsErrorState(result["message"]));
        }
      } else {
        emit(GetReportsErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetReportsErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
