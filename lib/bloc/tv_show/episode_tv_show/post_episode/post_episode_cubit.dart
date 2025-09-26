import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elite_admin/main.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
part 'post_episode_state.dart';

class PostTvShowEpisodeCubit extends Cubit<PostEpisodeState> {
  PostTvShowEpisodeCubit() : super(PostEpisodeInitial());

  Future<void> postEpisode({
    String? seriesId,
    String? seasonId,
    String? episodeName,
    String? episodeNo,
    String? releasedDate,
    File? coverImg,
    String? videoLink,
    String? movieTime,
    File? video,
  }) async {
    emit(PostEpisodeLoadingState());

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
        MapEntry("show_type", "tvshows"),
      ]);

      log("Form fields: ${formData.fields}");

      final response = await dio.post(
        AppUrls.episodeUrl,
        data: formData,
        options: Options(headers: headers),
        onSendProgress: (sent, total) {
          final percent = ((sent / total) * 100).clamp(0, 100).toInt();
          log("Upload progress: $percent%");
          emit(PostEpisodeProgressState(percent: percent));
        },
      );

      log("Response: ${response.data}");
      final result = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(PostEpisodeLoadedState());
        } else {
          emit(PostEpisodeErrorState(result['message'].toString()));
        }
      } else {
        emit(PostEpisodeErrorState("${result['message'] ?? "Server Error"}"));
      }
    } catch (e, s) {
      log("Error in postEpisode: $e, $s");
      emit(PostEpisodeErrorState("Exception: $e"));
    }
  }
}
