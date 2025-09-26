import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elite_admin/main.dart';
import 'package:equatable/equatable.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'post_film_state.dart';

class PostFilmCubit extends Cubit<PostFilmState> {
  PostFilmCubit() : super(PostFilmInitial());

  Future<void> postShortFilm({
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
  }) async {
    emit(PostFilmLoadingState());

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
      addFile("poster_img", posterImg);
      addFile("short_video", movieVideo);
      addFile("trailor_video", trailorVideo);

      formData.fields.addAll([
        if (movieName != null) MapEntry("short_film_title", movieName),
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
      ]);

      final response = await dio.post(
        "${AppUrls.shortFlimUrl}/create",
        data: formData,
        options: Options(headers: headers),
        onSendProgress: (sent, total) {
          final percent = ((sent / total) * 100).clamp(0, 100).toInt();
          log("Upload progress: $percent%");
          emit(PostFilmProgressState(percent: percent));
        },
      );

      log("Response: ${response.data}");
      final result = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(PostFilmLoadedState());
        } else {
          emit(PostFilmErrorState(result['message'].toString()));
        }
      } else {
        emit(PostFilmErrorState("${result['message'] ?? "Server Error"}"));
      }
    } catch (e) {
      log("Error: $e");
      emit(PostFilmErrorState(e.toString()));
    }
  }
}
