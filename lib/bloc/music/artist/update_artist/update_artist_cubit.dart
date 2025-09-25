import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
part 'update_artist_state.dart';

class UpdateArtistCubit extends Cubit<UpdateArtistState> {
  UpdateArtistCubit() : super(UpdateArtistInitial());

  updateArtistCategory({String? artistName, File? coverImg, required String id}) async {
    try {
      emit(UpdateArtistLoadingState());
      var request = http.MultipartRequest('PUT', Uri.parse("${AppUrls.musicArtistUrl}/$id"));
      request.headers.addAll(headers);
      if (artistName != null) request.fields['artist_name'] = artistName;
      if (coverImg != null) {
        final mimeType = lookupMimeType(coverImg.path);
        if (mimeType != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'profile_img',
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

      /// ---- Log cURL command for debugging ----
      final curlCommand = StringBuffer("curl -X PUT '${AppUrls.musicArtistUrl}/$id'");

      // Add headers
      headers.forEach((key, value) {
        curlCommand.write(" -H '$key: $value'");
      });

      // Add fields
      request.fields.forEach((key, value) {
        curlCommand.write(" -F '$key=$value'");
      });

      // Add file
      if (coverImg != null) {
        curlCommand.write(" -F 'profile_img=@${coverImg.path}'");
      }

      log("CURL: $curlCommand");

      /// ---------------------------------------

      log("Response: $result");
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            UpdateArtistLoadedState(),
          );
        } else {
          emit(UpdateArtistErrorState(result["message"]));
        }
      } else {
        emit(UpdateArtistErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        UpdateArtistErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
