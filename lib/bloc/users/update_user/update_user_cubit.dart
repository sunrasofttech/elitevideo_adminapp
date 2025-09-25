import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
part 'update_user_state.dart';

class UpdateUserCubit extends Cubit<UpdateUserState> {
  UpdateUserCubit() : super(UpdateUserInitial());

  updateUser({
    required String? id,
    String? name,
    File? profilePicture,
    String? email,
    String? mobileNo,
    String? password,
    String? appVersion,
  }) async {
    emit(UpdateUserLoadingState());
    try {
      var uri = Uri.parse("${AppUrls.userUrl}/admin/$id");
      var request = MultipartRequest("PUT", uri);

      request.headers.addAll(headers);

      if (profilePicture != null) {
        final mimeType = lookupMimeType(profilePicture.path);
        if (mimeType != null) {
          request.files.add(
            await MultipartFile.fromPath(
              "profile_picture",
              profilePicture.path,
              contentType: MediaType.parse(mimeType),
            ),
          );
        } else {
          log("Unable to determine MIME type for file: ${profilePicture.path}");
        }
      }

      Map<String, String> fields = {
        if (name != null) "name": name,
        if (email != null) "email": email.toString(),
        if (mobileNo != null) "mobile_no": mobileNo,
        if (password != null) "password": password,
        if (appVersion != null) "app_version": "appVersion",
      };

      request.fields.addAll(fields);

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      log("message == $responseData");
      final result = jsonDecode(responseData);

      log("Result: $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(UpdateUserLoadedState());
        } else {
          emit(UpdateUserErrorState("${result['message']}"));
        }
      } else {
        emit(UpdateUserErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(UpdateUserErrorState("$e $s"));
    }
  }
}
