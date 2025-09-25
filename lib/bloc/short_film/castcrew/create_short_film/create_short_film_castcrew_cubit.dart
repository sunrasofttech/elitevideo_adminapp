import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'create_short_film_castcrew_state.dart';

class CreateShortFilmCastcrewCubit extends Cubit<CreateShortFilmCastcrewState> {
  CreateShortFilmCastcrewCubit() : super(CreateShortFilmCastcrewInitial());

  createCastCrew({
    String? name,
    String? description,
    String? role,
    File? profileImg,
    String? movieId,
  }) async {
    emit(CreateShortFilmCastcrewLoadingState());
    try {
      var uri = Uri.parse("${AppUrls.shortFilmCastCrewUrl}/create");
      var request = MultipartRequest("POST", uri);

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
        if (description != null) "description": description,
        if (role != null) "role": role,
        if (movieId != null) "shortfilm_id": movieId,
      };

      request.fields.addAll(fields);

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      log("message == $responseData");
      final result = jsonDecode(responseData);

      log("Result: $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(CreateShortFilmCastcrewLoadedState());
        } else {
          emit(CreateShortFilmCastcrewErrorState("${result['message']}"));
        }
      } else {
        emit(CreateShortFilmCastcrewErrorState("Server error: ${response.statusCode}"));
      }
    } catch (e) {
      emit(CreateShortFilmCastcrewErrorState(e.toString()));
    }
  }
}
