import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/bloc/livetv/create/get_live_tv/get_live_tv_model.dart';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'get_live_tv_state.dart';

class GetLiveTvCubit extends Cubit<GetLiveTvState> {
  GetLiveTvCubit() : super(GetLiveTvInitial());
  getAllLiveCategory({
    int page = 1,
    int limit = 10,
    String? search,
    String? liveCatId,
  }) async {
    try {
      emit(GetLiveTvLoadingState());

      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParams['name'] = search;
      }

      if (liveCatId != null && liveCatId.isNotEmpty) {
        queryParams['live_category_id'] = liveCatId;
      }

      final uri = Uri.parse("${AppUrls.liveTvUrl}/admin/get-all").replace(queryParameters: queryParams);

      final response = await post(
        uri,
        headers: headers,
      );
      final result = jsonDecode(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetLiveTvLoadedState(
              getLiveModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetLiveTvErrorState("${result['message']}"));
        }
      } else {
        emit(GetLiveTvErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetLiveTvErrorState("$e $s"));
    }
  }
}
