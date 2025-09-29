import 'dart:developer';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:elite_admin/main.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:equatable/equatable.dart';
part 'post_trailer_state.dart';

class PostTrailerCubit extends Cubit<PostTrailerState> {
  PostTrailerCubit() : super(PostTrailerInitial());

  Future<void> postMovies({
    String? movieName,
    bool? status,
    String? description,
    File? coverImg,
    File? posterImg,
    File? trailerVideo,
  }) async {
    try {
      emit(PostTrailerLoadingState());

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
      addFile("trailor_video", trailerVideo);

      formData.fields.addAll([
        if (movieName != null) MapEntry("movie_name", movieName),
        if (status != null) MapEntry("status", status.toString()),
        if (description != null) MapEntry("description", description),
      ]);
      logCurl(formData);
      final response = await dio.post(
        "${AppUrls.baseUrl}/api/ott/trailor",
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
          emit(PostTrailerProgressState(percent: percent));
        },
      );
      log("---- 1 ${response.data} ${response.statusCode}");
      final result = response.data;

      log("---- 2 $result");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(PostTrailerLaodedState());
        } else {
          emit(PostTrailerErrorState("${result['message']}"));
        }
      } else {
        emit(PostTrailerErrorState("${result['message']}"));
      }
    } catch (e) {
      log("----$e");
      emit(PostTrailerErrorState(e.toString()));
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
