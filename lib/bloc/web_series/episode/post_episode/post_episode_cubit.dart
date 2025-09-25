import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
part 'post_episode_state.dart';

class PostEpisodeCubit extends Cubit<PostEpisodeState> {
  PostEpisodeCubit() : super(PostEpisodeInitial());

  postEpisode({
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
      var uri = Uri.parse(AppUrls.episodeUrl);
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

      await addFile("cover_img", coverImg);
      await addFile("video", video);

      Map<String, String> fields = {
        if (seriesId != null) "series_id": seriesId,
        if (seasonId != null) "season_id": seasonId.toString(),
        if (episodeName != null) "episode_name": episodeName,
        if (episodeNo != null) "episode_no": episodeNo,
        if (releasedDate != null) "released_date": releasedDate,
        if (movieTime != null) "movie_time": movieTime,
        if (videoLink != null) "video_link": videoLink,
         "show_type":"series",
      };

      log("message fields  $fields");

      request.fields.addAll(fields);

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      log("message == $responseData");
      final result = jsonDecode(responseData);

      log("Result: $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(PostEpisodeLoadedState());
        } else {
          emit(PostEpisodeErrorState("${result['message']}"));
        }
      } else {
        emit(PostEpisodeErrorState("Server error: ${response.statusCode}"));
      }
    } catch (e) {
      emit(PostEpisodeErrorState(e.toString()));
    }
  }
}
