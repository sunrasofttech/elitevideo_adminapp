import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:elite_admin/utils/apiurls/api.dart';
part 'update_category_state.dart';

class UpdateCategoryCubit extends Cubit<UpdateCategoryState> {
  UpdateCategoryCubit() : super(UpdateCategoryInitial());

  updateCategory({
    required String id,
    String? name,
    bool? status,
    File? img,
  }) async {
    try {
      emit(UpdateCategoryLoadingState());

      var request = http.MultipartRequest('PUT', Uri.parse("${AppUrls.movieCategoryUrl}/$id"));
      request.headers.addAll(headers);
      if (name != null) request.fields['name'] = name;
      if (status != null) request.fields['status'] = status.toString();
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

      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            UpdateCategoryLoadedState(),
          );
        } else {
          emit(UpdateCategoryErrorState(result["message"]));
        }
      } else {
        emit(UpdateCategoryErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        UpdateCategoryErrorState(
          "catch error ${AppUrls.movieCategoryUrl}/$id} $e, $s",
        ),
      );
    }
  }
}
