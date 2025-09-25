import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'send_notification_state.dart';

class SendNotificationCubit extends Cubit<SendNotificationState> {
  SendNotificationCubit() : super(SendNotificationInitial());

  sendNotification(
    String title,
    String subTitle,
  ) async {
    try {
      emit(SendNotificationLoadingState());
      var response = await post(
        Uri.parse(AppUrls.sendNotificationUrl),
        body: jsonEncode({
          "title": title,
          "message": subTitle,
        }),
        headers: headers,
      );

      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            SendNotificationLoadedState(),
          );
        } else {
          emit(SendNotificationErrorState(result["message"]));
        }
      } else {
        emit(SendNotificationErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        SendNotificationErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
