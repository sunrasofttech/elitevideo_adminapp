import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/bloc/setting/get_setting/get_setting_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'get_setting_state.dart';

class GetSettingCubit extends Cubit<GetSettingState> {
  GetSettingCubit() : super(GetSettingInitial());

  getSetting() async {
    try {
      emit(GetSettingLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.settingUrl}/get"),
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetSettingLoadedState(
              getSettingModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetSettingErrorState(result["message"]));
        }
      } else {
        emit(GetSettingErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetSettingErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
