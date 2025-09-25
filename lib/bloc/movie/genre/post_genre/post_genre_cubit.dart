import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'post_genre_state.dart';

class PostGenreCubit extends Cubit<PostGenreState> {
  PostGenreCubit() : super(PostGenreInitial());

  postGenre({
    String? name,
    File? coverImg,
    bool? status,
  }) async {
    emit(PostGenreLoadingState());
    try {
      var uri = Uri.parse(AppUrls.genreUrl);
      var request = MultipartRequest("POST", uri);

      request.headers.addAll(headers);

      if (coverImg != null) {
        final mimeType = lookupMimeType(coverImg.path);
        if (mimeType != null) {
          request.files.add(
            await MultipartFile.fromPath(
              "cover_img",
              coverImg.path,
              contentType: MediaType.parse(mimeType),
            ),
          );
        } else {
          log("Unable to determine MIME type for file: ${coverImg.path}");
        }
      }

      Map<String, String> fields = {
        if (name != null) "name": name,
        if (status != null) "status": status.toString(),
      };

      request.fields.addAll(fields);

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      log("message == $responseData");
      final result = jsonDecode(responseData);

      log("Result: $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(PostGenreLaodedState());
        } else {
          emit(PostGenreErrorState("${result['message']}"));
        }
      } else {
        emit(PostGenreErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(PostGenreErrorState("$e $s"));
    }
  }
}
