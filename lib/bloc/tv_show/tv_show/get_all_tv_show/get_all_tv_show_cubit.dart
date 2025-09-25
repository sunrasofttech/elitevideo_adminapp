import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/bloc/tv_show/tv_show/get_all_tv_show/get_all_tv_show_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'get_all_tv_show_state.dart';

class GetAllTvShowSeriesCubit extends Cubit<GetAllSeriesState> {
  GetAllTvShowSeriesCubit() : super(GetAllSeriesInitial());

  getAllSeries({
    String? languageId,
    String? categoryId,
    String? name,
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      emit(GetAllSeriesLoadingState());

      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        'show_type': 'tvshows',
      };

      if (languageId != null && languageId.trim().isNotEmpty) {
        queryParams['language'] = languageId.trim();
      }
      if (categoryId != null && categoryId.trim().isNotEmpty) {
        queryParams['category'] = categoryId.trim();
      }
      if (name != null && name.trim().isNotEmpty) {
        queryParams['name'] = name.trim();
      }
      if (search != null && search.trim().isNotEmpty) {
        queryParams['name'] = search.trim();
      }

      final uri = Uri.parse("${AppUrls.seriesUrl}/admin/get-all").replace(
        queryParameters: queryParams,
      );

      log("GetAllTvShowSeriesCubit => $uri");
      final response = await post(
        uri,
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("getAllSeries =>  $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllSeriesLoadedState(
              getSeriesModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllSeriesErrorState(result["message"]));
        }
      } else {
        emit(GetAllSeriesErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetAllSeriesErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
