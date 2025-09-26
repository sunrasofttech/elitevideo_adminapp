import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elite_admin/main.dart';
import 'package:equatable/equatable.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'create_music_state.dart';

class CreateMusicCubit extends Cubit<CreateMusicState> {
  CreateMusicCubit() : super(CreateMusicInitial());

  Future<void> createMusic({
    String? musicName,
    String? artistName,
    bool? status,
    String? description,
    File? coverImg,
    String? categoryId,
    File? songFile,
    bool? isPopular,
    String? artistId,
    String? languageId,
  }) async {
    try {
      emit(CreateMusicLoadingState());

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

      formData.fields.addAll([
        if (musicName != null) MapEntry("song_title", musicName),
        if (description != null) MapEntry("description", description),
        if (status != null) MapEntry("status", status.toString()),
        if (artistName != null) MapEntry("artist_name", artistName),
        if (categoryId != null) MapEntry("category_id", categoryId),
        if (isPopular != null) MapEntry("is_popular", isPopular.toString()),
        if (artistId != null) MapEntry("artist_id", artistId),
        if (languageId != null) MapEntry("language_id", languageId),
      ]);

      final response = await dio.post(
        AppUrls.musicUrl,
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
          emit(CreateMusicProgressState(percent: percent));
        },
      );

      log("Response data: ${response.data}");

      final result = response.data;
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(CreateMusicLoadedState());
        } else {
          emit(CreateMusicErrorState(result['message'].toString()));
        }
      } else {
        emit(CreateMusicErrorState("${result['message'] ?? "Server Error"}"));
      }
    } catch (e) {
      log("Error: $e");
      emit(CreateMusicErrorState(e.toString()));
    }
  }
}
