import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/bloc/livetv/category/get_live_category/get_live_category_model.dart';
import 'package:http/http.dart';
import '../../../../utils/apiurls/api.dart';
part 'get_live_category_state.dart';

class GetLiveCategoryCubit extends Cubit<GetLiveCategoryState> {
  GetLiveCategoryCubit() : super(GetLiveCategoryInitial());

  getAllLiveCategory() async {
    try {
      emit(GetLiveCategoryLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.liveTvCategory}/get-all"),
        headers: headers,
      );
      final result = jsonDecode(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetLiveCategoryLoadedState(
              getLiveCategoryModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetLiveCategoryErrorState("${result['message']}"));
        }
      } else {
        emit(GetLiveCategoryErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetLiveCategoryErrorState("$e $s"));
    }
  }
}
