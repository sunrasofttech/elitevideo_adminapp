import 'dart:convert';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/bloc/dashboard/get_dashboard/get_dashboard_model.dart';
import '../../../utils/apiurls/api.dart';

part 'get_dashboard_state.dart';

class GetDashboardCubit extends Cubit<GetDashboardState> {
  GetDashboardCubit() : super(GetDashboardInitial());

  getDashboard() async {
    try {
      emit(GetDashboardLoadingState());
      var response = await post(
        Uri.parse(AppUrls.dashboardUrl),
        headers: headers,
      );
      final result = jsonDecode(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetDashboardLoadedState(
              getDashboardModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetDashboardErrorState("${result['message']}"));
        }
      } else {
        emit(GetDashboardErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetDashboardErrorState("$e $s"));
    }
  }
}
