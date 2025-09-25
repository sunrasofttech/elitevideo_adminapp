import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:elite_admin/utils/apiurls/api.dart';
part 'post_category_state.dart';

class PostCategoryCubit extends Cubit<PostCategoryState> {
  PostCategoryCubit() : super(PostCategoryInitial());

  postCategory(
    String name,
    File? img,
    bool status,
  ) async {
    try {
      emit(PostCategoryLoadingState());

      var request = http.MultipartRequest('POST', Uri.parse(AppUrls.movieCategoryUrl));
      request.headers.addAll(headers);
      request.fields['name'] = name;
      request.fields['status'] = status.toString();
      if (img != null) {
        final mimeType = lookupMimeType(img.path);
        if (mimeType != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'img',
              img.path,
              contentType: MediaType.parse(mimeType),
            ),
          );
        } else {
          log("Unable to determine MIME type for file: ${img.path}");
        }
      }

      // Send the request
      var response = await request.send();

      // Wait for response and parse it
      var responseData = await http.Response.fromStream(response);
      final result = jsonDecode(responseData.body);

      log("Response: $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            PostCategoryLoadedState(),
          );
        } else {
          emit(PostCategoryErrorState(result["message"]));
        }
      } else {
        emit(PostCategoryErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        PostCategoryErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
