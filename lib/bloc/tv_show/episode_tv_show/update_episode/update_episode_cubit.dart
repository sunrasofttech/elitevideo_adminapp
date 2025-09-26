import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elite_admin/main.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
part 'update_episode_state.dart';

class UpdateTvShowEpisodeCubit extends Cubit<UpdateEpisodeState> {
  UpdateTvShowEpisodeCubit() : super(UpdateEpisodeInitial());

  Future<void> updateEpisode({
    required String id,
    String? seriesId,
    String? seasonId,
    String? episodeName,
    String? episodeNo,
    String? releasedDate,
    File? coverImg,
    File? video,
    String? movieTime,
    String? videoLink,
    bool? status,
  }) async {
    emit(UpdateEpisodeLoadingState());

    try {
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
      addFile("video", video);

      formData.fields.addAll([
        if (seriesId != null) MapEntry("series_id", seriesId),
        if (seasonId != null) MapEntry("season_id", seasonId),
        if (episodeName != null) MapEntry("episode_name", episodeName),
        if (episodeNo != null) MapEntry("episode_no", episodeNo),
        if (releasedDate != null) MapEntry("released_date", releasedDate),
        if (movieTime != null) MapEntry("movie_time", movieTime),
        if (videoLink != null) MapEntry("video_link", videoLink),
        if (status != null) MapEntry("status", status.toString()),
        MapEntry("show_type", "tvshows"),
      ]);

      log("Form fields: ${formData.fields}");

      final response = await dio.put(
        "${AppUrls.episodeUrl}/$id",
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
        },
      );

      log("Response: ${response.data}");
      final result = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(UpdateEpisodeLoadedState());
        } else {
          emit(UpdateEpisodeErrorState(result['message'].toString()));
        }
      } else {
        emit(UpdateEpisodeErrorState("${result['message'] ?? "Server Error"}"));
      }
    } catch (e, s) {
      log("Error in updateEpisode: $e, $s");
      emit(UpdateEpisodeErrorState("Exception: $e"));
    }
  }
}
