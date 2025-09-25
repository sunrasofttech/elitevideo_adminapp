import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit() : super(UpdateProfileInitial());

  updateProfile({
    String? name,
    String? password,
    String? email,
    File? profileImg,
    Map<String, dynamic>? selectedPermissions,
    String? userId,
  }) async {
    emit(UpdateProfileLoadingState());

    try {
      var uri = Uri.parse("${AppUrls.updateProfileUrl}$userId");
      var request = MultipartRequest("PUT", uri);

      request.headers.addAll(headers);

      Future<void> addFile(String fieldName, File? file) async {
        if (file != null) {
          final mimeType = lookupMimeType(file.path);
          if (mimeType != null) {
            request.files.add(
              await MultipartFile.fromPath(
                fieldName,
                file.path,
                contentType: MediaType.parse(mimeType),
              ),
            );
          } else {
            log("Unable to determine MIME type for file: ${file.path}");
          }
        }
      }

      await addFile("profile_img", profileImg);

      Map<String, String> fields = {
        if (name != null) "name": name,
        if (password != null) "password": password,
        if (email != null) "email": email,
        if (selectedPermissions != null)
          "selectedPermissions": jsonEncode(
            selectedPermissions.entries.where((e) => e.value == true).map((e) => e.key).toList(),
          ),
      };

      request.fields.addAll(fields);

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      log("📥 Response: $responseData");
      final result = jsonDecode(responseData);

      final buffer = StringBuffer();
      buffer.write("curl -X PUT '${uri.toString()}' \\\n");

      request.headers.forEach((key, value) {
        buffer.write("  -H '$key: $value' \\\n");
      });

      request.fields.forEach((key, value) {
        buffer.write("  --form '$key=$value' \\\n");
      });

      for (final file in request.files) {
        buffer.write("  --form '${file.field}=@${file.filename}' \\\n");
      }

      log("🧪 cURL command:\n${buffer.toString()}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(UpdateProfileLoadedState());
        } else {
          emit(UpdateProfileErrorState(result['msg'] ?? "Something went wrong"));
        }
      } else {
        emit(UpdateProfileErrorState(result['msg'] ?? "Error ${response.statusCode}"));
      }
    } catch (e, st) {
      log("❌ Exception: $e\n$st");
      emit(UpdateProfileErrorState(e.toString()));
    }
  }
}
