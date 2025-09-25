import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'update_subscription_state.dart';

class UpdateSubscriptionCubit extends Cubit<UpdateSubscriptionState> {
  UpdateSubscriptionCubit() : super(UpdateSubscriptionInitial());

  uodateSubScription({
    required String id,
    String? planName,
    String? numberOfDeviceThatLogged,
    String? amount,
    String? timeDuration,
    bool? status,
    String? maxVideoQuality,
    bool? allContent,
    bool? watchonTvLaptop,
    bool? addfreeMovieShows,
  }) async {
    try {
      emit(UpdateSubscriptionLoadingState());
      var response = await put(
        Uri.parse("${AppUrls.subscriptionPlanUrl}/$id"),
        body: jsonEncode(
          {
            "plan_name": planName,
            "all_content": allContent,
            "watchon_tv_laptop": watchonTvLaptop,
            "addfree_movie_shows": addfreeMovieShows,
            "number_of_device_that_logged": numberOfDeviceThatLogged,
            "max_video_quality": maxVideoQuality,
            "amount": amount,
            "time_duration": timeDuration,
            "status": status,
          }..removeWhere((k, v) => v == null),
        ),
        headers: headers,
      );

      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            UpdateSubscriptionLoadedState(),
          );
        } else {
          emit(UpdateSubscriptionErrorState(result["message"]));
        }
      } else {
        emit(UpdateSubscriptionErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        UpdateSubscriptionErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
