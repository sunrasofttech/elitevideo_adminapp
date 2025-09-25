import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'post_user_state.dart';

class PostUserCubit extends Cubit<PostUserState> {
  PostUserCubit() : super(PostUserInitial());

  postUser({
    String? name,
    String? mobileNo,
    String? email,
    String? password,

  }) async {
    try {
      emit(PostUserLoadingState());
      var response = await post(
        Uri.parse(AppUrls.signUpUserUrl),
        body: json.encode(
          {
            "name": name,
            "mobile_no": mobileNo,
            "email": email,
            "password": password,
          },
        ),
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            PostUserLoadedState(),
          );
        } else {
          emit(PostUserErrorState(result["message"]));
        }
      } else {
        emit(PostUserErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        PostUserErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
