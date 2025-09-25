import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
part 'update_genre_state.dart';

class UpdateGenreCubit extends Cubit<UpdateGenreState> {
  UpdateGenreCubit() : super(UpdateGenreInitial());

  updateGenre({
    required String? id,
    String? name,
    bool? status,
    File? coverImg,
  }) async {
    emit(UpdateGenreLoadingState());
    try {
      var uri = Uri.parse("${AppUrls.genreUrl}/$id");
      var request = MultipartRequest("PUT", uri);

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
          emit(UpdateGenreLoadedState());
        } else {
          emit(UpdateGenreErrorState("${result['message']}"));
        }
      } else {
        emit(UpdateGenreErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(UpdateGenreErrorState("$e $s"));
    }
  }
}
