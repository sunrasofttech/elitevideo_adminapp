import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'delete_admin_state.dart';

class DeleteAdminCubit extends Cubit<DeleteAdminState> {
  DeleteAdminCubit() : super(DeleteAdminInitial());

  deleteUser(String id) async {
    try {
      emit(DeleteAdminLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.updateProfileUrl}/$id"),
        headers: headers,
      );
      final result = jsonDecode(response.body.toString());

      log("message = = => ${AppUrls.updateProfileUrl}/$id");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteAdminLoadedState(),
          );
        } else {
          emit(DeleteAdminErrorState("${result['message']}"));
        }
      } else {
        emit(DeleteAdminErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(DeleteAdminErrorState("$e $s"));
    }
  }
}
