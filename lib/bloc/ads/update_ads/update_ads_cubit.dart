import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
part 'update_ads_state.dart';

class UpdateAdsCubit extends Cubit<UpdateAdsState> {
  UpdateAdsCubit() : super(UpdateAdsInitial());

  updateAds({
     String? videoTime,
    String? adUrl,
    String? skipTime,
    File? adVideo,
    required String id,
  }) async {
    try {
      emit(UpdateAdsLoadingState());

      var request = http.MultipartRequest('PUT', Uri.parse("${AppUrls.adsUrl}/$id"));
      request.headers.addAll(headers);

      if (videoTime != null) request.fields['video_time'] = videoTime;
      if (adUrl != null) request.fields['title'] = adUrl.toString();
      if (skipTime != null) request.fields['skip_time'] = skipTime;
      if (adVideo != null) {
        final mimeType = lookupMimeType(adVideo.path);
        if (mimeType != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'ad_video',
              adVideo.path,
              contentType: MediaType.parse(mimeType),
            ),
          );
        } else {
          log("Unable to determine MIME type for file: ${adVideo.path}");
        }
      }

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);
      final result = jsonDecode(responseData.body);

      log("UpdateAdsCubit: $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            UpdateAdsLoadedState(),
          );
        } else {
          emit(UpdateAdsErrorState(result["message"]));
        }
      } else {
        emit(UpdateAdsErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        UpdateAdsErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
