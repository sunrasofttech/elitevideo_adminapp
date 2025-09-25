import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'createlivetv_state.dart';

class CreatelivetvCubit extends Cubit<CreatelivetvState> {
  CreatelivetvCubit() : super(CreatelivetvInitial());

  createLiveTV({
    String? name,
    String? liveCategoryId,
    String? androidChannelUrl,
    String? iosChannelUrl,
    String? description,
    bool? status,
    File? coverImg,
    File? posterImg,
    bool? is_livetv_on_rent,
  }) async {
    try {
      emit(CreatelivetvLoadingState());

      var request = http.MultipartRequest('POST', Uri.parse(AppUrls.liveTvUrl));
      request.headers.addAll(headers);

      if (name != null) request.fields['name'] = name;
      if (status != null) request.fields['status'] = status.toString();
      if (liveCategoryId != null) request.fields['live_category_id'] = liveCategoryId;
      if (description != null) request.fields['description'] = description;
      if (androidChannelUrl != null) request.fields['android_channel_url'] = androidChannelUrl;
      if (iosChannelUrl != null) request.fields['ios_channel_url'] = iosChannelUrl;
      if(is_livetv_on_rent!=null) request.fields['is_livetv_on_rent'] = is_livetv_on_rent.toString();
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

        if (posterImg != null) {
        final mimeType = lookupMimeType(posterImg.path);
        if (mimeType != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'poster_img',
              posterImg.path,
              contentType: MediaType.parse(mimeType),
            ),
          );
        } else {
          log("Unable to determine MIME type for file: ${posterImg.path}");
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
            CreatelivetvLoadedState(),
          );
        } else {
          emit(CreatelivetvErrorState(result["message"]));
        }
      } else {
        emit(CreatelivetvErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        CreatelivetvErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
