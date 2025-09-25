import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'create_subscription_state.dart';

class CreateSubscriptionCubit extends Cubit<CreateSubscriptionState> {
  CreateSubscriptionCubit() : super(CreateSubscriptionInitial());

  createSubScription({
    required String planName,
    required String numberOfDeviceThatLogged,
    required String amount,
    required String timeDuration,
    required bool status,
    required String maxVideoQuality,
    required bool allContent,
    required bool watchonTvLaptop,
    required bool addfreeMovieShows,
  }) async {
    try {
      emit(CreateSubscriptionLoadingState());
      var response = await post(
        Uri.parse(AppUrls.subscriptionPlanUrl),
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
          },
        ),
        headers: headers,
      );

      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            CreateSubscriptionLoadedState(),
          );
        } else {
          emit(CreateSubscriptionErrorState(result["message"]));
        }
      } else {
        emit(CreateSubscriptionErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        CreateSubscriptionErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
