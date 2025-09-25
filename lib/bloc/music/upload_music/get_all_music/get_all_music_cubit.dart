import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/bloc/music/upload_music/get_all_music/get_all_music_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'get_all_music_state.dart';

class GetAllMusicCubit extends Cubit<GetAllMusicState> {
  GetAllMusicCubit() : super(GetAllMusicInitial());

  getAllMusic({int page = 1, String? search}) async {
    try {
      emit(GetAllMusicLoadingState());

      // Build query parameters
      String url = "${AppUrls.musicUrl}/admin/get-all?page=$page&limit=10";
      if (search != null && search.trim().isNotEmpty) {
        url += "&search=${Uri.encodeComponent(search)}";
      }

      var response = await post(
        Uri.parse(url),
        headers: headers,
      );

      final result = jsonDecode(response.body);
      log("getAllMusic =>  $result $url $headers");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllMusicLoadedState(
              getMusicModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllMusicErrorState(result["message"]));
        }
      } else {
        emit(GetAllMusicErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetAllMusicErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
