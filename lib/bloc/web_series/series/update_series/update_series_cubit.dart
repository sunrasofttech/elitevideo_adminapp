import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
part 'update_series_state.dart';

class UpdateSeriesCubit extends Cubit<UpdateSeriesState> {
  UpdateSeriesCubit() : super(UpdateSeriesInitial());

  updateSeries({
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
      var uri = Uri.parse("${AppUrls.seriesUrl}/$id");
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

      log("message = == = = ${rentedTimeDays} ");
      Map<String, String> fields = {
        if (movieName != null) "series_name": movieName,
        if (status != null) "status": status.toString(),
        if (movieLanguage != null) "movie_language": movieLanguage,
        if (genreId != null) "genre_id": genreId,
        if (description != null) "description": description,
        if (releasedBy != null) "released_by": releasedBy,
        if (releasedDate != null) "released_date": releasedDate,
        if (movieCategoryId != null) "movie_category": movieCategoryId,
        if (showSubscription != null) "show_subscription": showSubscription.toString(),
        if (seriesRentPrice != null) "series_rent_price": seriesRentPrice,
        if (rentedTimeDays != null) "rented_time_days": rentedTimeDays,
        if (isSeriesOnRent != null) "is_series_on_rent": isSeriesOnRent.toString(),
        if (isHighlighted != null) "is_highlighted": isHighlighted.toString(),
         "show_type":"series",
      };

      request.fields.addAll(fields);

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      log("message == $responseData");
      final result = jsonDecode(responseData);

      log("Result: $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(UpdateSeriesLoadedState());
        } else {
          emit(UpdateSeriesErrorState("${result['message']}"));
        }
      } else {
        emit(UpdateSeriesErrorState("Server error: ${response.statusCode}"));
      }
    } catch (e) {
      emit(UpdateSeriesErrorState(e.toString()));
    }
  }
}
