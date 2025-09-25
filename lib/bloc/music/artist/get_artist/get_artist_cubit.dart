import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/bloc/music/artist/get_artist/get_artist_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'get_artist_state.dart';

class GetArtistCubit extends Cubit<GetArtistState> {
  GetArtistCubit() : super(GetArtistInitial());

  getAllArtist() async {
    try {
      emit(GetArtistLoadingState());

      final uri = Uri.parse(AppUrls.musicArtistUrl);

      final response = await get(
        uri,
        headers: headers,
      );

      final result = jsonDecode(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetArtistLoadedState(
              getAllArtistModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetArtistErrorState("${result['message']}"));
        }
      } else {
        emit(GetArtistErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetArtistErrorState("$e $s"));
    }
  }
}
