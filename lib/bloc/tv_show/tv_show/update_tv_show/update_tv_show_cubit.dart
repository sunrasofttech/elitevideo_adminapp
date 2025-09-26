import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elite_admin/main.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
part 'update_tv_show_state.dart';

class UpdateTvShowSeriesCubit extends Cubit<UpdateSeriesState> {
  UpdateTvShowSeriesCubit() : super(UpdateSeriesInitial());

  Future<void> updateSeries({
    required String id,
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
    bool? isSeriesOnRent,
    String? rentedTimeDays,
    bool? isHighlighted,
  }) async {
    emit(UpdateSeriesLoadingState());

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
        if (rentedTimeDays != null) MapEntry("rented_time_days", rentedTimeDays),
        if (isSeriesOnRent != null) MapEntry("is_series_on_rent", isSeriesOnRent.toString()),
        if (isHighlighted != null) MapEntry("is_highlighted", isHighlighted.toString()),
        MapEntry("show_type", "tvshows"),
      ]);

      final response = await dio.put(
        "${AppUrls.seriesUrl}/$id",
        data: formData,
        options: Options(headers: headers),
        onSendProgress: (sent, total) {
          final percent = ((sent / total) * 100).clamp(0, 100).toInt();
          emit(UpdateSeriesProgressState(percent: percent));
        },
      );

      log("Response: ${response.data}");
      final result = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(UpdateSeriesLoadedState());
        } else {
          emit(UpdateSeriesErrorState(result['message'].toString()));
        }
      } else {
        emit(UpdateSeriesErrorState("${result['message'] ?? "Server Error"}"));
      }
    } catch (e, s) {
      log("Error in updateSeries: $e, $s");
      emit(UpdateSeriesErrorState("Exception: $e"));
    }
  }
}
