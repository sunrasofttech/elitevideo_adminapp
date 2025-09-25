import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'create_subadmin_state.dart';

class CreateSubadminCubit extends Cubit<CreateSubadminState> {
  CreateSubadminCubit() : super(CreateSubadminInitial());

  createSubAdmin({
    required String name,
    required String password,
    required Map<String, dynamic> selectedPermissions,
  }) async {
    try {
      emit(CreateSubadminLoadingState());
      var response = await post(
        Uri.parse(AppUrls.signUpUrl),
        body: jsonEncode({
          "name": name,
          "password": password,
          "role": "subadmin",
          "selectedPermissions": selectedPermissions,
        }),
        headers: headers,
      );

      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            CreateSubadminLoadedState(),
          );
        } else {
          emit(CreateSubadminErrorState(result["message"]));
        }
      } else {
        emit(CreateSubadminErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        CreateSubadminErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
