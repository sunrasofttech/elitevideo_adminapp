import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/bloc/auth/login/login_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  login(
    String username,
    String password,
  ) async {
    try {
      emit(LoginLoadingState());
      var response = await post(
        Uri.parse(AppUrls.loginUrl),
        body: jsonEncode(
          {
            "name": username,
            "password": password,
          },
        ),
        headers: headers,
      );

      final result = jsonDecode(response.body);
      log("login => $username $password $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            LoginLoadededState(
              loginModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(LoginErrorState(result["message"]));
        }
      } else {
        emit(LoginErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        LoginErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
