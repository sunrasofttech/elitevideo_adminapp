import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'delete_music_category_state.dart';

class DeleteMusicCategoryCubit extends Cubit<DeleteMusicCategoryState> {
  DeleteMusicCategoryCubit() : super(DeleteMusicCategoryInitial());

  deleteMusicCategory(String id) async {
    try {
      emit(DeleteMusicCategoryLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.musicCategoryUrl}/$id"),
        headers: headers,
      );
      final result = jsonDecode(response.body.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteMusicCategoryLoadedState(),
          );
        } else {
          emit(DeleteMusicCategoryErrorState("${result['message']}"));
        }
      } else {
        emit(DeleteMusicCategoryErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(DeleteMusicCategoryErrorState("$e $s"));
    }
  }
}
