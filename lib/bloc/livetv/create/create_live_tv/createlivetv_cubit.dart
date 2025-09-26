import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elite_admin/main.dart';
import 'package:equatable/equatable.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'createlivetv_state.dart';

class CreatelivetvCubit extends Cubit<CreatelivetvState> {
  CreatelivetvCubit() : super(CreatelivetvInitial());

  Future<void> createLiveTV({
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
    emit(CreatelivetvLoadingState());

    try {
      FormData formData = FormData();

      void addFile(String fieldName, File? file) {
        if (file != null) {
          final mimeType = lookupMimeType(file.path)?.split("/") ?? ["application", "octet-stream"];
          formData.files.add(
            MapEntry(
              fieldName,
              MultipartFile.fromFileSync(
                file.path,
                filename: file.path.split("/").last,
                contentType: MediaType(mimeType[0], mimeType[1]),
              ),
            ),
          );
        }
      }

      addFile("cover_img", coverImg);
      addFile("poster_img", posterImg);

      formData.fields.addAll([
        if (name != null) MapEntry("name", name),
        if (status != null) MapEntry("status", status.toString()),
        if (liveCategoryId != null) MapEntry("live_category_id", liveCategoryId),
        if (description != null) MapEntry("description", description),
        if (androidChannelUrl != null) MapEntry("android_channel_url", androidChannelUrl),
        if (iosChannelUrl != null) MapEntry("ios_channel_url", iosChannelUrl),
        if (is_livetv_on_rent != null) MapEntry("is_livetv_on_rent", is_livetv_on_rent.toString()),
      ]);

      final response = await dio.post(
        AppUrls.liveTvUrl,
        data: formData,
        options: Options(headers: headers),
        onSendProgress: (sent, total) {
          final percent = ((sent / total) * 100).clamp(0, 100).toInt();
          log("Upload progress: $percent%");
          emit(CreateFilmProgressState(percent: percent));
        },
      );

      log("Response: ${response.data}");
      final result = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(CreatelivetvLoadedState());
        } else {
          emit(CreatelivetvErrorState(result['message'].toString()));
        }
      } else {
        emit(CreatelivetvErrorState("${result['message'] ?? "Server Error"}"));
      }
    } catch (e, s) {
      log("catch error $e, $s");
      emit(CreatelivetvErrorState("catch error $e"));
    }
  }
}
