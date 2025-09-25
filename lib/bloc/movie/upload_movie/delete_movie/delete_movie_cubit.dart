import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'delete_movie_state.dart';

class DeleteMovieCubit extends Cubit<DeleteMovieState> {
  DeleteMovieCubit() : super(DeleteMovieInitial());

  deleteMovie(List<String> id) async {
    try {
      if (id.isEmpty) {
        emit(DeleteMovieErrorState("No Id Selected"));
      }
      emit(DeleteMovieLoadingState());
      var response = await delete(
        Uri.parse(AppUrls.movieUrl),
        
        body: json.encode({
          "ids": id,
        }),
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteMovieLoadedState(),
          );
        } else {
          emit(DeleteMovieErrorState(result["message"]));
        }
      } else {
        emit(DeleteMovieErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        DeleteMovieErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
