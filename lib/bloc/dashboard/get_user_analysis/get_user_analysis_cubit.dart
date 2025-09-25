import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/bloc/dashboard/get_user_analysis/get_user_analysis_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'get_user_analysis_state.dart';

class GetUserAnalysisCubit extends Cubit<GetUserAnalysisState> {
  GetUserAnalysisCubit() : super(GetUserAnalysisInitial());

  getUserAnalysis({String? year}) async {
    try {
      emit(GetUserAnalysisLoadingState());
      final currentYear = year ?? DateTime.now().year.toString();

      var response = await post(
        Uri.parse("${AppUrls.userAnaylsisUrl}?year=$currentYear"),
        headers: headers,
      );
      final result = jsonDecode(response.body.toString());

      log("Result : - $result");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetUserAnalysisLoadedState(
              getUserAnalysisModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetUserAnalysisErrorState("${result['message']}"));
        }
      } else {
        emit(GetUserAnalysisErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetUserAnalysisErrorState("$e $s"));
    }
  }
}
