import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
part 'update_music_state.dart';

class UpdateMusicCubit extends Cubit<UpdateMusicState> {
  UpdateMusicCubit() : super(UpdateMusicInitial());

  updateMusic({
    String? musicName,
    required String id,
    String? artistName,
    bool? status,
    String? description,
    File? coverImg,
    File? songFile,
    bool? isPopular,
    String? artistId,
    String? languageId,
  }) async {
    emit(UpdateMusicLoadingState());
    try {
      var uri = Uri.parse("${AppUrls.musicUrl}/$id");
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

      await addFile("cover_img", coverImg);
      await addFile("song_file", songFile);

      Map<String, String> fields = {
        if (musicName != null) "song_title": musicName,
        if (description != null) "description": description,
        if (status != null) "status": status.toString(),
        if (artistName != null) "artist_name": artistName.toString(),
        if (isPopular != null) 'is_popular': isPopular.toString(),
        if (artistId != null) 'artist_id': artistId,
        if (languageId != null) 'language_id': languageId,
      };

      request.fields.addAll(fields);

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      log("message == $responseData");
      final result = jsonDecode(responseData);

      log("Result: $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(UpdateMusicLoadedState());
        } else {
          emit(UpdateMusicErrorState("${result['message']}"));
        }
      } else {
        emit(UpdateMusicErrorState("Server error: ${response.statusCode}"));
      }
    } catch (e) {
      emit(UpdateMusicErrorState(e.toString()));
    }
  }
}
