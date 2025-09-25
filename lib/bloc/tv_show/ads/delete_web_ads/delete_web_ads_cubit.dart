import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'delete_web_ads_state.dart';

class DeleteTvShowWebAdsCubit extends Cubit<DeleteWebAdsState> {
  DeleteTvShowWebAdsCubit() : super(DeleteWebAdsInitial());

  deletetvShowAds(String id) async {
    try {
      emit(DeleteWebAdsLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.seasonAdsUrl}/$id"),
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteWebAdsLoadedState(),
          );
        } else {
          emit(DeleteWebAdsErrorState(result["message"]));
        }
      } else {
        emit(DeleteWebAdsErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        DeleteWebAdsErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
