import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'delete_subscription_state.dart';

class DeleteSubscriptionCubit extends Cubit<DeleteSubscriptionState> {
  DeleteSubscriptionCubit() : super(DeleteSubscriptionInitial());

  deleteSubscription(String id) async {
    try {
      emit(DeleteSubscriptionLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.subscriptionPlanUrl}/$id"),
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteSubscriptionLoadedState(),
          );
        } else {
          emit(DeleteSubscriptionErrorState(result["message"]));
        }
      } else {
        emit(DeleteSubscriptionErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        DeleteSubscriptionErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
