import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:elite_admin/utils/apiurls/api.dart';

part 'post_artist_state.dart';

class PostArtistCubit extends Cubit<PostArtistState> {
  PostArtistCubit() : super(PostArtistInitial());

  postArtistCategory(String artistName, {File? coverImg}) async {
    try {
      emit(PostArtistLoadingState());
      var request = http.MultipartRequest('POST', Uri.parse(AppUrls.musicArtistUrl));
      request.headers.addAll(headers);
      request.fields['artist_name'] = artistName;
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

      log("Response: $result");
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            PostArtistLoadedState(),
          );
        } else {
          emit(PostArtistErrorState(result["message"]));
        }
      } else {
        emit(PostArtistErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        PostArtistErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
