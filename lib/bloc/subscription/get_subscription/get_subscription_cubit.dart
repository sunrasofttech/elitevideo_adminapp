import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/bloc/subscription/get_subscription/get_subscription_model.dart';
import 'package:http/http.dart';

import '../../../utils/apiurls/api.dart';
part 'get_subscription_state.dart';

class GetSubscriptionCubit extends Cubit<GetSubscriptionState> {
  GetSubscriptionCubit() : super(GetSubscriptionInitial());

  getAllSub() async {
    try {
      emit(GetSubscriptionLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.subscriptionPlanUrl}/admin/get-all"),
        headers: headers,
      );
      final result = jsonDecode(response.body.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetSubscriptionLoadedState(
              getAllSubscriptionModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetSubscriptionErrorState("${result['message']}"));
        }
      } else {
        emit(GetSubscriptionErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetSubscriptionErrorState("$e $s"));
    }
  }
}
