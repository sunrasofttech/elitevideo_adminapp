import 'dart:convert';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'delete_movie_ads_state.dart';

class DeleteMovieAdsCubit extends Cubit<DeleteMovieAdsState> {
  DeleteMovieAdsCubit() : super(DeleteMovieAdsInitial());

  deleteMovieAds(String id) async {
    try {
      emit(DeleteMovieAdsLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.movieAdsUrl}/$id"),
          headers: headers,
      );
      final result = jsonDecode(response.body.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteMovieAdsLoadedState(),
          );
        } else {
          emit(DeleteMovieAdsErrorState("${result['message']}"));
        }
      } else {
        emit(DeleteMovieAdsErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(DeleteMovieAdsErrorState("$e $s"));
    }
  }
}
