import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:elite_admin/bloc/trailer/get_all_trailer/get_all_trailer_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

part 'get_all_trailer_state.dart';

class GetAllTrailerCubit extends Cubit<GetAllTrailerState> {
  GetAllTrailerCubit() : super(GetAllTrailerInitial());

  getAllTrailer({String? movieName, int page = 1, int limit = 10}) async {
    try {
      emit(GetAllTrailerLoadingState());

      final queryParams = {'movie_name': movieName ?? '', 'page': page.toString(), 'limit': limit.toString()};

      final uri = Uri.parse("${AppUrls.baseUrl}/api/ott/trailor").replace(queryParameters: queryParams);
      log("getAllTrailer -----------  $uri");
      final response = await get(uri, headers: headers);

      final result = jsonDecode(response.body);
      log("getAllTrailer =>  $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(GetAllTrailerLoadedState(getAllTrailorsModelFromJson(json.encode(result))));
        } else {
          emit(GetAllTrailerErrorState(result["message"]));
        }
      } else {
        emit(GetAllTrailerErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetAllTrailerErrorState("catch error $e, $s"));
    }
  }
}
