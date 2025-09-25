import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/bloc/movie/cast_crew/get_all_castcrew/get_all_castcrew_model.dart';

import '../../../../utils/apiurls/api.dart';
part 'get_all_castcrew_state.dart';

class GetAllCastcrewCubit extends Cubit<GetAllCastcrewState> {
  GetAllCastcrewCubit() : super(GetAllCastcrewInitial());

  Future<void> getAllCastCrew({int page = 1, int limit = 10, String? movieId, String? name}) async {
    try {
      emit(GetAllCastcrewLoadingState());

      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (name != null) "name": name,
        if (movieId != null) 'movie_id': movieId,
      };

      final uri = Uri.parse("${AppUrls.castCrewUrl}/get-all").replace(queryParameters: queryParams);

      var response = await post(
        uri,
        headers: headers,
      );

      final result = jsonDecode(response.body.toString());
      log("Result :- $result $uri");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllCastcrewLoadedState(
              getAllCastCrewModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllCastcrewErrorState("${result['message']}"));
        }
      } else {
        emit(GetAllCastcrewErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetAllCastcrewErrorState("$e $s"));
    }
  }
}
