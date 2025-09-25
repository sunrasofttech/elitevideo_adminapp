import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/bloc/dashboard/get_revenue_analysis/get_revenue_analysis_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'get_revenue_anaylsis_state.dart';

class GetRevenueAnaylsisCubit extends Cubit<GetRevenueAnaylsisState> {
  GetRevenueAnaylsisCubit() : super(GetRevenueAnaylsisInitial());

  getRevenueAnalysis({String? year}) async {
    try {
      emit(GetRevenueAnaylsisLoadingState());

      final currentYear = year ?? DateTime.now().year.toString();

      var response = await post(
        Uri.parse("${AppUrls.revenueAnaylsisUrl}?year=$currentYear"),
        headers: headers,
      );
      final result = jsonDecode(response.body.toString());

      log("Result : - $result");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetRevenueAnaylsisLoadedState(
              getRevenueModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetRevenueAnaylsisErrorState("${result['message']}"));
        }
      } else {
        emit(GetRevenueAnaylsisErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetRevenueAnaylsisErrorState("$e $s"));
    }
  }
}
