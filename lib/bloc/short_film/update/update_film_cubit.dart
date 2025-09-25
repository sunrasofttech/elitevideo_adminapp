import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'update_film_state.dart';

class UpdateFilmCubit extends Cubit<UpdateFilmState> {
  UpdateFilmCubit() : super(UpdateFilmInitial());

  updateShortFilm({
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
    dynamic movieVideo,
    String? video_link,
    String? trailor_video_link,
    dynamic trailorVideo,
    int? rented_time_days,
    bool? showSubscription,
  }) async {
    emit(UpdateFilmLoadingState());
    try {
      var uri = Uri.parse("${AppUrls.shortFlimUrl}/$id");
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
      await addFile("poster_img", posterImg);
      await addFile("short_video", movieVideo);
      await addFile("trailor_video", trailorVideo);

      Map<String, String> fields = {
        if (movieName != null) "short_film_title": movieName,
        if (video_link != null) "video_link": video_link,
        if (trailor_video_link != null) "trailor_video_link": trailor_video_link,
        if (status != null) "status": status.toString(),
        if (movieLanguage != null) "movie_language": movieLanguage,
        if (genreId != null) "genre_id": genreId,
        if (quality != null) "quality": quality.toString(),
        if (subtitle != null) "subtitle": subtitle.toString(),
        if (description != null) "description": description,
        if (isMovieOnRent != null) "is_movie_on_rent": isMovieOnRent.toString(),
        if (movieTime != null) "movie_time": movieTime,
        if (movieRentPrice != null) "movie_rent_price": movieRentPrice,
        if (isHighlighted != null) "is_highlighted": isHighlighted.toString(),
        if (releasedBy != null) "released_by": releasedBy,
        if (releasedDate != null) "released_date": releasedDate,
        if (movieCategoryId != null) "movie_category": movieCategoryId,
        if (rented_time_days != null) "rented_time_days": rented_time_days.toString(),
        if (showSubscription != null) "show_subscription": showSubscription.toString(),
      };

      request.fields.addAll(fields);

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      log("message == $responseData");
      final result = jsonDecode(responseData);

      log("Result: $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(UpdateFilmLoadedState());
        } else {
          emit(UpdateFilmErrorState("${result['message']}"));
        }
      } else {
        emit(UpdateFilmErrorState("Server error: ${response.statusCode}"));
      }
    } catch (e) {
      emit(UpdateFilmErrorState(e.toString()));
    }
  }
}
