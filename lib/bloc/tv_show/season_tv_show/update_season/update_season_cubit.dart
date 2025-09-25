import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'update_season_state.dart';

class UpdateTvShowSeasonCubit extends Cubit<UpdateSeasonState> {
  UpdateTvShowSeasonCubit() : super(UpdateSeasonInitial());

  updateSeason({
    required String id,
    String? seasonName,
    bool? status,
  }) async {
    try {
      emit(UpdateSeasonLoadingState());
      var response = await put(
        Uri.parse("${AppUrls.seasonUrl}/$id"),
        body: jsonEncode(
          {
            "status": status,
            "season_name": seasonName,
            "show_type": "tvshows",
          }..removeWhere(
              (k, v) => v == null,
            ),
        ),
        headers: headers,
      );

      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            UpdateSeasonLoadedState(),
          );
        } else {
          emit(UpdateSeasonErrorState(result["message"]));
        }
      } else {
        emit(UpdateSeasonErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        UpdateSeasonErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
