import 'package:bloc/bloc.dart';
import 'package:elite_admin/main.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
part 'update_trailer_state.dart';

class UpdateTrailerCubit extends Cubit<UpdateTrailerState> {
  UpdateTrailerCubit() : super(UpdateTrailerInitial());


    updateMovies({
    required String id,
      String? movieName,
    bool? status,
    String? description,
    File? coverImg,
    File? posterImg,
    File? trailerVideo,
  }) async {
    try {
      emit(UpdateTrailerLoadingState());

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
      await addFile("trailor_video", trailerVideo);

      // Add text fields
      formData.fields.addAll([
        if (movieName != null) MapEntry("movie_name", movieName),
        if (status != null) MapEntry("status", status.toString()),
        if (description != null) MapEntry("description", description),
      
      ]);

      var response = await dio.put(
        "${AppUrls.baseUrl}/api/ott/trailor/$id",
        data: formData,
        options: Options(
          headers: headers,
          validateStatus: (status) {
            return true;
          },
        ),

        onSendProgress: (sent, total) {
          final percent = ((sent / total) * 100).clamp(0, 100).toInt();

          emit(
           UpdateTrailerProgressState(
              percent: percent,
            ),
          );
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['status'] == true) {
          emit(UpdateTrailerLoadedState());
        } else {
          emit(UpdateTrailerErrorState("${response.data['message']}"));
        }
      } else {
        emit(UpdateTrailerErrorState("${response.data['message'] ?? "Server Error"}"));
      }
    } catch (e) {
      emit(UpdateTrailerErrorState(e.toString()));
    }
  }
}
