import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'delete_user_state.dart';

class DeleteUserCubit extends Cubit<DeleteUserState> {
  DeleteUserCubit() : super(DeleteUserInitial());

  deleteUser(String id) async {
    try {
      emit(DeleteUserLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.userUrl}/$id"),
          headers: headers,
      );
      final result = jsonDecode(response.body.toString());

      log("message = = => ${AppUrls.userUrl}/$id");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteUserLoadedState(),
          );
        } else {
          emit(DeleteUserErrorState("${result['message']}"));
        }
      } else {
        emit(DeleteUserErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(DeleteUserErrorState("$e $s"));
    }
  }
}
