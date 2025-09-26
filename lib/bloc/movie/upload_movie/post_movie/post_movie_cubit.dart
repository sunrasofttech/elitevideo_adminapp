import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:elite_admin/main.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'post_movie_state.dart';

class PostMovieCubit extends Cubit<PostMovieState> {
  PostMovieCubit() : super(PostMovieInitial());

  Future<void> postMovies({
    String? movieName,
    bool? status,
    String? movieLanguage,
    String? movieCategoryId,
    String? genreId,
    bool? quality,
    bool? subtitle,
    String? description,
    String? movieTime,
    String? movieRentPrice,
    bool? isHighlighted,
    bool? isMovieOnRent,
    String? releasedBy,
    String? releasedDate,
    File? coverImg,
    File? posterImg,
    dynamic movieVideo,
    String? video_link,
    String? trailor_video_link,
    dynamic trailorVideo,
    int? rented_time_days,
    bool? showSubscription,
    String? position,
  }) async {
    try {
      emit(PostMovieLoadingState());

      dio.options.headers.addAll(headers);

      FormData formData = FormData();

      void addFile(String fieldName, File? file) {
        if (file != null) {
          final mimeType = lookupMimeType(file.path);
          if (mimeType != null) {
            formData.files.add(
              MapEntry(
                fieldName,
                MultipartFile.fromFileSync(
                  file.path,
                  filename: file.path.split("/").last,
                  contentType: MediaType.parse(mimeType),
                ),
              ),
            );
          }
        }
      }

      addFile("cover_img", coverImg);
      addFile("poster_img", posterImg);
      addFile("movie_video", movieVideo);
      addFile("trailor_video", trailorVideo);

      formData.fields.addAll([
        if (movieName != null) MapEntry("movie_name", movieName),
        if (video_link != null) MapEntry("video_link", video_link),
        if (trailor_video_link != null) MapEntry("trailor_video_link", trailor_video_link),
        if (status != null) MapEntry("status", status.toString()),
        if (movieLanguage != null) MapEntry("movie_language", movieLanguage),
        if (genreId != null) MapEntry("genre_id", genreId),
        if (quality != null) MapEntry("quality", quality.toString()),
        if (subtitle != null) MapEntry("subtitle", subtitle.toString()),
        if (description != null) MapEntry("description", description),
        if (isMovieOnRent != null) MapEntry("is_movie_on_rent", isMovieOnRent.toString()),
        if (movieTime != null) MapEntry("movie_time", movieTime),
        if (movieRentPrice != null) MapEntry("movie_rent_price", movieRentPrice),
        if (isHighlighted != null) MapEntry("is_highlighted", isHighlighted.toString()),
        if (releasedBy != null) MapEntry("released_by", releasedBy),
        if (releasedDate != null) MapEntry("released_date", releasedDate),
        if (movieCategoryId != null) MapEntry("movie_category", movieCategoryId),
        if (rented_time_days != null) MapEntry("rented_time_days", rented_time_days.toString()),
        if (showSubscription != null) MapEntry("show_subscription", showSubscription.toString()),
        if (position != null) MapEntry("position", position),
      ]);
      logCurl(formData);
      final response = await dio.post(
        AppUrls.movieUrl,
        data: formData,
        options: Options(
          headers: headers,
          validateStatus: (status) {
            return true;
          },
        ),
        onSendProgress: (sent, total) {
          final percent = ((sent / total) * 100).clamp(0, 100).toInt();
          final elapsed = 1;
          final speed = sent / (elapsed > 0 ? elapsed : 1);
          final remaining = total - sent;
          final etaSeconds = speed > 0 ? (remaining / speed).toInt() : 0;
          log("----------- $percent  $etaSeconds");
          emit(
            PostMovieProgressState(
              percent: percent,
              eta: Duration(seconds: etaSeconds),
            ),
          );
        },
      );
      log("---- 1 ${response.data} ${response.statusCode}");
      final result = response.data;

      log("---- 2 $result");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(PostMovieLoadedState());
        } else {
          emit(PostMovieErrorState("${result['message']}"));
        }
      } else {
        emit(PostMovieErrorState("${result['message']}"));
      }
    } catch (e) {
      log("----$e");
      emit(PostMovieErrorState(e.toString()));
    }
  }
}

void logCurl(FormData formData) {
  final buffer = StringBuffer();
  buffer.write('curl -X POST "${AppUrls.movieUrl}"');

  // Headers
  dio.options.headers.forEach((key, value) {
    buffer.write(' -H "$key: $value"');
  });

  // Fields
  for (var field in formData.fields) {
    buffer.write(' -F "${field.key}=${field.value}"');
  }

  // Files
  for (var file in formData.files) {
    final filename = file.value.filename ?? "file";
    buffer.write(' -F "${file.key}=@$filename"');
  }

  log("CURL: ${buffer.toString()}");
}
