import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
part 'update_episode_state.dart';

class UpdateEpisodeCubit extends Cubit<UpdateEpisodeState> {
  UpdateEpisodeCubit() : super(UpdateEpisodeInitial());

  updateEpisode({
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
      var uri = Uri.parse("${AppUrls.episodeUrl}/$id");
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
      await addFile("video", video);

      Map<String, String> fields = {
        if (seriesId != null) "series_id": seriesId,
        if (seasonId != null) "season_id": seasonId.toString(),
        if (episodeName != null) "episode_name": episodeName,
        if (episodeNo != null) "episode_no": episodeNo,
        if (releasedDate != null) "released_date": releasedDate,
        if (status != null) "status": status.toString(),
        if (movieTime != null) "movie_time": movieTime,
        if (videoLink != null) "video_link": videoLink,
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
          emit(UpdateEpisodeLoadedState());
        } else {
          emit(UpdateEpisodeErrorState("${result['message']}"));
        }
      } else {
        emit(UpdateEpisodeErrorState("Server error: ${response.statusCode}"));
      }
    } catch (e) {
      emit(UpdateEpisodeErrorState(e.toString()));
    }
  }
}
