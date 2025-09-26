import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elite_admin/main.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
part 'post_series_state.dart';

class PostSeriesCubit extends Cubit<PostSeriesState> {
  PostSeriesCubit() : super(PostSeriesInitial());

  Future<void> postSeries({
    String? movieName,
    bool? status,
    String? movieLanguage,
    String? movieCategoryId,
    String? genreId,
    String? releasedBy,
    String? releasedDate,
    String? description,
    File? coverImg,
    File? posterImg,
    String? seriesRentPrice,
    bool? showSubscription,
    String? rentedTimeDays,
    bool? isSeriesOnRent,
    bool? isHighlighted,
  }) async {
    emit(PostSeriesLoadingState());
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

      formData.fields.addAll([
        if (movieName != null) MapEntry("series_name", movieName),
        if (status != null) MapEntry("status", status.toString()),
        if (movieLanguage != null) MapEntry("movie_language", movieLanguage),
        if (genreId != null) MapEntry("genre_id", genreId),
        if (description != null) MapEntry("description", description),
        if (releasedBy != null) MapEntry("released_by", releasedBy),
        if (releasedDate != null) MapEntry("released_date", releasedDate),
        if (movieCategoryId != null) MapEntry("movie_category", movieCategoryId),
        if (showSubscription != null) MapEntry("show_subscription", showSubscription.toString()),
        if (seriesRentPrice != null) MapEntry("series_rent_price", seriesRentPrice),
        if (isSeriesOnRent != null) MapEntry("is_series_on_rent", isSeriesOnRent.toString()),
        if (rentedTimeDays != null && rentedTimeDays.isNotEmpty) MapEntry("rented_time_days", rentedTimeDays),
        if (isHighlighted != null) MapEntry("is_highlighted", isHighlighted.toString()),
        MapEntry("show_type", "series"),
      ]);

      final response = await dio.post(
        AppUrls.seriesUrl,
        data: formData,
        options: Options(
          headers: headers,
          validateStatus: (status) {
            return true;
          },
        ),
        onSendProgress: (sent, total) {
          final percent = ((sent / total) * 100).clamp(0, 100).toInt();
          emit(PostSeriesProgressState(percent: percent));
        },
      );

      log("Response data: ${response.data}");
      final result = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(PostSeriesLoadedState());
        } else {
          emit(PostSeriesErrorState(result['message'].toString()));
        }
      } else {
        emit(PostSeriesErrorState("${result['message'] ?? "Server Error"}"));
      }
    } catch (e) {
      log("Error: $e");
      emit(PostSeriesErrorState(e.toString()));
    }
  }
}
