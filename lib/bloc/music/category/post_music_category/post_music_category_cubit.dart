import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
part 'post_music_category_state.dart';

class PostMusicCategoryCubit extends Cubit<PostMusicCategoryState> {
  PostMusicCategoryCubit() : super(PostMusicCategoryInitial());

  postMusicCategory(String name, {File? coverImg}) async {
    try {
      emit(PostMusicCategoryLoadingState());

      var request = http.MultipartRequest('POST', Uri.parse(AppUrls.musicCategoryUrl));
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
            PostMusicCategoryLoadedState(),
          );
        } else {
          emit(PostMusicCategoryErrorState(result["message"]));
        }
      } else {
        emit(PostMusicCategoryErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        PostMusicCategoryErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
