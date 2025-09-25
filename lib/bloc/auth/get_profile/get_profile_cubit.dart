import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:elite_admin/bloc/auth/get_profile/get_profile_model.dart';
import 'package:elite_admin/main.dart';
import 'package:elite_admin/presentation/auth/login_screen.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:elite_admin/utils/preferences/local_preferences.dart';
part 'get_profile_state.dart';

class GetProfileCubit extends Cubit<GetProfileState> {
  GetProfileCubit() : super(GetProfileInitial());

  getProfile(BuildContext context) async {
    try {
      emit(GetProfileLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.getProfileUrl}$userId"),
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("GetProfileCubit  ${AppUrls.getProfileUrl}$userId $result $headers");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetProfileLoadedState(
              getAdminProfileModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetProfileErrorState(result["message"]));
          if (result["message"] == "Admin not found") {
            LocalStorageUtils.clear().then((e) => {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  )
                });
          }
        }
      } else {
        emit(GetProfileErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetProfileErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
