import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'delete_category_state.dart';

class DeleteCategoryCubit extends Cubit<DeleteCategoryState> {
  DeleteCategoryCubit() : super(DeleteCategoryInitial());

  deleteMovieCategory(String id) async {
    try {
      emit(DeleteCategoryLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.movieCategoryUrl}/$id"),
          headers: headers,
      );
      final result = jsonDecode(response.body.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteCategoryLoadedState(),
          );
        } else {
          emit(DeleteCategoryErrorState("${result['message']}"));
        }
      } else {
        emit(DeleteCategoryErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(DeleteCategoryErrorState("$e $s"));
    }
  }
}
