import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/bloc/subadmin/get_subadmin/get_subadmin_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'get_subadmin_state.dart';

class GetSubadminCubit extends Cubit<GetSubadminState> {
  GetSubadminCubit() : super(GetSubadminInitial());

  getSubAdmins() async {
    try {
      emit(GetSubadminLoadingState());
      var response = await post(
        Uri.parse(AppUrls.subAdminUrl),
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetSubadminLaodedState(
              getAllSubAdminModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetSubadminErrorState(result["message"]));
        }
      } else {
        emit(GetSubadminErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetSubadminErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
