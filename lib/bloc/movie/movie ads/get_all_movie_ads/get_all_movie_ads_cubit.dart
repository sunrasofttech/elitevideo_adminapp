import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/bloc/movie/movie%20ads/get_all_movie_ads/get_all_movie_ads_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'get_all_movie_ads_state.dart';

class GetAllMovieAdsCubit extends Cubit<GetAllMovieAdsState> {
  GetAllMovieAdsCubit() : super(GetAllMovieAdsInitial());

  Future<void> getAllMovies({int page = 1, int limit = 10}) async {
    try {
      emit(GetAllMovieAdsLoadingState());

      final uri = Uri.parse("${AppUrls.movieAdsUrl}/getall").replace(queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      });

      var response = await post(
        uri,
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllMovieAdsLaodedState(movieAdsModelFromJson(jsonEncode(result))),
          );
        } else {
          emit(GetAllMovieAdsErrorState(result["message"]));
        }
      } else {
        emit(GetAllMovieAdsErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetAllMovieAdsErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
