import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart' as http;
part 'update_music_category_state.dart';

class UpdateMusicCategoryCubit extends Cubit<UpdateMusicCategoryState> {
  UpdateMusicCategoryCubit() : super(UpdateMusicCategoryInitial());

  updateMusic(
    String name,
    String id,
    File? coverImg,
  ) async {
    try {
      emit(UpdateMusicCategoryLoadingState());

      var request = http.MultipartRequest('PUT', Uri.parse("${AppUrls.musicCategoryUrl}/$id"));
      request.headers.addAll(headers);
      request.fields['name'] = name;
      if (coverImg != null) {
        final mimeType = lookupMimeType(coverImg.path);
        if (mimeType != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'cover_img',
              coverImg.path,
              contentType: MediaType.parse(mimeType),
            ),
          );
        } else {
          log("Unable to determine MIME type for file: ${coverImg.path}");
        }
      }

      // Send the request
      var response = await request.send();

      // Wait for response and parse it
      var responseData = await http.Response.fromStream(response);
      final result = jsonDecode(responseData.body);

      log("Response: $result");
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            UpdateMusicCategoryLoadedState(),
          );
        } else {
          emit(UpdateMusicCategoryErrorState(result["message"]));
        }
      } else {
        emit(UpdateMusicCategoryErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        UpdateMusicCategoryErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
