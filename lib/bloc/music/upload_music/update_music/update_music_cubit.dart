import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:elite_admin/main.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
part 'update_music_state.dart';

class UpdateMusicCubit extends Cubit<UpdateMusicState> {
  UpdateMusicCubit() : super(UpdateMusicInitial());

  Future<void> updateMusic({
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
    try {
      emit(UpdateMusicLoadingState());

      FormData formData = FormData();

      void addFile(String fieldName, File? file) {
        if (file != null) {
          final mimeType = lookupMimeType(file.path)?.split("/") ?? ["application", "octet-stream"];
          formData.files.add(
            MapEntry(
              fieldName,
              MultipartFile.fromFileSync(
                file.path,
                filename: file.path.split("/").last,
                contentType: MediaType(mimeType[0], mimeType[1]),
              ),
            ),
          );
        }
      }

      addFile("cover_img", coverImg);
      addFile("song_file", songFile);

      // Add normal fields
      formData.fields.addAll([
        if (musicName != null) MapEntry("song_title", musicName),
        if (description != null) MapEntry("description", description),
        if (status != null) MapEntry("status", status.toString()),
        if (artistName != null) MapEntry("artist_name", artistName),
        if (isPopular != null) MapEntry("is_popular", isPopular.toString()),
        if (artistId != null) MapEntry("artist_id", artistId),
        if (languageId != null) MapEntry("language_id", languageId),
      ]);

      final response = await dio.put(
        "${AppUrls.musicUrl}/$id",
        data: formData,
        options: Options(
          headers: headers,
          validateStatus: (status) {
            return true;
          },
        ),
        onSendProgress: (sent, total) {
          final percent = ((sent / total) * 100).clamp(0, 100).toInt();
          log("Upload progress: $percent%");
          emit(UpdateMusicProgressState(percent: percent));
        },
      );

      log("Response data: ${response.data}");
      final result = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(UpdateMusicLoadedState());
        } else {
          emit(UpdateMusicErrorState(result['message'].toString()));
        }
      } else {
        emit(UpdateMusicErrorState("${result['message'] ?? "Server Error"}"));
      }
    } catch (e) {
      log("Error: $e");
      emit(UpdateMusicErrorState(e.toString()));
    }
  }
}
