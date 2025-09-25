import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/bloc/music/category/get_all_music_category/get_all_music_category_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'get_all_music_category_state.dart';

class GetAllMusicCategoryCubit extends Cubit<GetAllMusicCategoryState> {
  GetAllMusicCategoryCubit() : super(GetAllMusicCategoryInitial());

  getAllMusic({String? search, int page = 1}) async {
    try {
      emit(GetAllMusicCategoryLoadingState());

      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': '10',
      };

      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }

      final uri = Uri.parse("${AppUrls.musicCategoryUrl}/admin/get-all").replace(
        queryParameters: queryParams,
      );

      final response = await post(
        uri,
        headers: headers,
      );

      final result = jsonDecode(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllMusicCategoryLoadedState(
              getAllMusicModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllMusicCategoryErrorState("${result['message']}"));
        }
      } else {
        emit(GetAllMusicCategoryErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetAllMusicCategoryErrorState("$e $s"));
    }
  }
}
