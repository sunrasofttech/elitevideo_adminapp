import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'create_ads_state.dart';

class CreateAdsCubit extends Cubit<CreateAdsState> {
  CreateAdsCubit() : super(CreateAdsInitial());

  createAds({
    String? videoTime,
    String? adUrl,
    String? skipTime,
    File? adVideo,
  }) async {
    try {
      emit(CreateAdsLoadingState());

      var request = http.MultipartRequest('POST', Uri.parse(AppUrls.adsUrl));
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

      log("Response: $result");
      log("CreateAdsCubit $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            CreateAdsLaodedState(),
          );
        } else {
          emit(CreateAdsErrorState(result["message"]));
        }
      } else {
        emit(CreateAdsErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        CreateAdsErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
