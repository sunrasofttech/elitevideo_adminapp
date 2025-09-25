import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'delete_live_category_state.dart';

class DeleteLiveCategoryCubit extends Cubit<DeleteLiveCategoryState> {
  DeleteLiveCategoryCubit() : super(DeleteLiveCategoryInitial());

  deleteLiveCategory(String id) async {
    try {
      emit(DeleteLiveCategoryLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.liveTvCategory}/$id"),
        headers: headers,
      );
      final result = jsonDecode(response.body.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteLiveCategoryLoadedState(),
          );
        } else {
          emit(DeleteLiveCategoryErrorState("${result['message']}"));
        }
      } else {
        emit(DeleteLiveCategoryErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(DeleteLiveCategoryErrorState("$e $s"));
    }
  }
}
