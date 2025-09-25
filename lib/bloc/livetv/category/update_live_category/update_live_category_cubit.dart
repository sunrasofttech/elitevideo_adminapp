import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'update_live_category_state.dart';

class UpdateLiveCategoryCubit extends Cubit<UpdateLiveCategoryState> {
  UpdateLiveCategoryCubit() : super(UpdateLiveCategoryInitial());

  updateLiveCategory({required String id, String? name, bool? status, File? coverImg}) async {
    try {
      emit(UpdateLiveCategoryLoadingState());

      var request = http.MultipartRequest('PUT', Uri.parse("${AppUrls.liveTvCategory}/$id"));
      request.headers.addAll(headers);

      if (name != null) request.fields['name'] = name;
      if (status != null) request.fields['status'] = status.toString();
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

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);
      final result = jsonDecode(responseData.body);

      log("Response: $result");
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            UpdateLiveCategoryLoadedState(),
          );
        } else {
          emit(UpdateLiveCategoryErrorState(result["message"]));
        }
      } else {
        emit(UpdateLiveCategoryErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        UpdateLiveCategoryErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
