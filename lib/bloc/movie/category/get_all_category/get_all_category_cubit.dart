import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/bloc/movie/category/get_all_category/get_all_category_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'get_all_category_state.dart';

class GetAllMovieCategoryCubit extends Cubit<GetAllCategoryState> {
  GetAllMovieCategoryCubit() : super(GetAllCategoryInitial());

  getAllMovieCategory({String? name, int page = 1}) async {
    try {
      emit(GetAllCategoryLoadingState());
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': '5',
      };
      if (name != null && name.trim().isNotEmpty) {
        queryParams['name'] = name.trim();
      }

      final uri = Uri.parse("${AppUrls.movieCategoryUrl}/get-all").replace(
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
            GetAllCategoryLoadedState(
              getAllMovieCategoryModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllCategoryErrorState("${result['message']}"));
        }
      } else {
        emit(GetAllCategoryErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetAllCategoryErrorState("$e $s"));
    }
  }
}
