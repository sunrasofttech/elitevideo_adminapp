import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'delete_short_film_ads_state.dart';

class DeleteShortFilmAdsCubit extends Cubit<DeleteShortFilmAdsState> {
  DeleteShortFilmAdsCubit() : super(DeleteShortFilmAdsInitial());

  deleteShortFilm(String id) async {
    try {
      emit(DeleteShortFilmAdsLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.shortFilmsAds}/$id"),
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteShortFilmAdsLoadedState(),
          );
        } else {
          emit(DeleteShortFilmAdsErrorState(result["message"]));
        }
      } else {
        emit(DeleteShortFilmAdsErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        DeleteShortFilmAdsErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
