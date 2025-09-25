import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'update_cast_crew_short_film_state.dart';

class UpdateCastCrewShortFilmCubit extends Cubit<UpdateCastCrewShortFilmState> {
  UpdateCastCrewShortFilmCubit() : super(UpdateCastCrewShortFilmInitial());

  updateCastCrew({
    String? name,
    String? description,
    String? role,
    String? id,
    File? profileImg,
    String? movieId,
  }) async {
    emit(UpdateCastCrewShortFilmLoadingState());
    try {
      var uri = Uri.parse("${AppUrls.shortFilmCastCrewUrl}/$id");
      var request = MultipartRequest("PUT", uri);

      request.headers.addAll(headers);

      log("📤 API URL: ${request.url}");
      log("📤 Headers: ${request.headers}");

      Future<void> addFile(String fieldName, File? file) async {
        if (file != null) {
          final mimeType = lookupMimeType(file.path);
          if (mimeType != null) {
            final multipartFile = await MultipartFile.fromPath(
              fieldName,
              file.path,
              contentType: MediaType.parse(mimeType),
            );
            request.files.add(multipartFile);

            log("📎 Added file field '$fieldName': ${file.path} (MIME: $mimeType)");
          } else {
            log("⚠️ Unable to determine MIME type for file: ${file.path}");
          }
        }
      }

      await addFile("profile_img", profileImg);

      Map<String, String> fields = {
        if (name != null) "name": name,
        if (description != null) "description": description,
        if (role != null) "role": role,
        if (movieId != null) "shortfilm_id": movieId,
      };

      request.fields.addAll(fields);
      log("📄 Form Fields: $fields");

      var response = await request.send();

      final responseBody = await response.stream.bytesToString();
      log("✅ Status Code: ${response.statusCode}");
      log("✅ Response Body: $responseBody");
      final result = jsonDecode(responseBody);

      log("Result: $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(UpdateCastCrewShortFilmLaodedState());
        } else {
          emit(UpdateCastCrewShortFilmErrorState("${result['message']}"));
        }
      } else {
        emit(UpdateCastCrewShortFilmErrorState("Server error: ${response.statusCode}"));
      }
    } catch (e) {
      emit(UpdateCastCrewShortFilmErrorState(e.toString()));
    }
  }
}
