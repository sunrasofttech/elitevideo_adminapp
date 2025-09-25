import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
part 'update_cast_crew_webseries_state.dart';

class UpdateCastCrewWebseriesCubit extends Cubit<UpdateCastCrewWebseriesState> {
  UpdateCastCrewWebseriesCubit() : super(UpdateCastCrewWebseriesInitial());

  updateCastCrew({
    String? name,
    String? description,
    String? role,
    String? id,
    File? profileImg,
    String? movieId,
  }) async {
    emit(UpdateCastCrewWebseriesLoadingState());
    try {
      var uri = Uri.parse("${AppUrls.webSeriesCastCrewUrl}/$id");
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
        if (description != null) "description": description,
        if (role != null) "role": role,
        if (movieId != null) "series_id": movieId,
        "show_type": "series",
      };

      request.fields.addAll(fields);

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      log("message == $responseData");
      final result = jsonDecode(responseData);

      log("Result: $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(UpdateCastCrewWebseriesLoadedState());
        } else {
          emit(UpdateCastCrewWebseriesErrorState("${result['message']}"));
        }
      } else {
        emit(UpdateCastCrewWebseriesErrorState("Server error: ${response.statusCode}"));
      }
    } catch (e) {
      emit(UpdateCastCrewWebseriesErrorState(e.toString()));
    }
  }
}
