import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elite_admin/main.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
part 'update_movie_state.dart';

class UpdateMovieCubit extends Cubit<UpdateMovieState> {
  UpdateMovieCubit() : super(UpdateMovieInitial());

  updateMovies({
    required String id,
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
    File? movieVideo,
    File? trailorVideo,
    String? video_link,
    String? trailor_video_link,
    int? rented_time_days,
    bool? showSubscription,
    String? position,
  }) async {
    try {
      emit(UpdateMovieLoadingState());

      FormData formData = FormData();

      Future<void> addFile(String fieldName, File? file) async {
        if (file != null) {
          final mimeType = lookupMimeType(file.path);
          if (mimeType != null) {
            formData.files.add(
              MapEntry(
                fieldName,
                await MultipartFile.fromFile(
                  file.path,
                  filename: file.path.split('/').last,
                  contentType: MediaType.parse(mimeType),
                ),
              ),
            );
          }
        }
      }

      await addFile("cover_img", coverImg);
      await addFile("poster_img", posterImg);
      await addFile("movie_video", movieVideo);
      await addFile("trailor_video", trailorVideo);

      // Add text fields
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

      var response = await dio.put(
        "${AppUrls.movieUrl}/$id",
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

          emit(
            UpdateMovieProgressState(
              percent: percent,
              eta: Duration(seconds: etaSeconds),
            ),
          );
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['status'] == true) {
          emit(UpdateMovieLoadedState());
        } else {
          emit(UpdateMovieErrorState("${response.data['message']}"));
        }
      } else {
        emit(UpdateMovieErrorState("${response.data['message'] ?? "Server Error"}"));
      }
    } catch (e) {
      emit(UpdateMovieErrorState(e.toString()));
    }
  }
}
