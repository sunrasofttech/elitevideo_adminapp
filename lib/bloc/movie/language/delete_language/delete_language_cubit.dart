import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'delete_language_state.dart';

class DeleteLanguageCubit extends Cubit<DeleteLanguageState> {
  DeleteLanguageCubit() : super(DeleteLanguageInitial());

  deleteLanguage(String id) async {
    try {
      emit(DeleteLanguageLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.movieLanguageUrl}/$id"),
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteLanguageLoadedState(),
          );
        } else {
          emit(DeleteLanguageErrorState(result["message"]));
        }
      } else {
        emit(DeleteLanguageErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        DeleteLanguageErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
