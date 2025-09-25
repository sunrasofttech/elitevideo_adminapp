import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/bloc/users/get_all_user/get_all_user_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'get_all_user_state.dart';

class GetAllUserCubit extends Cubit<GetAllUserState> {
  GetAllUserCubit() : super(GetAllUserInitial());

  getAllUser({
    int page = 1,
    int limit = 10,
    String? name,
    String? mobileNo,
  }) async {
    try {
      emit(GetAllUserLoadingState());

      final queryParams = <String, String>{};

      queryParams['page'] = page.toString();
      queryParams['limit'] = limit.toString();
      if (name != null && name.trim().isNotEmpty) queryParams['name'] = name.trim();
      if (mobileNo != null && mobileNo.trim().isNotEmpty) queryParams['mobile_no'] = mobileNo.trim();

      final uri = Uri.parse(AppUrls.userUrl).replace(queryParameters: queryParams);

      log("User API URL => $uri");

      final response = await post(uri, headers: headers);
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllUserLoadedState(
              getAllUserModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllUserErrorState(result["message"]));
        }
      } else {
        emit(GetAllUserErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetAllUserErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
