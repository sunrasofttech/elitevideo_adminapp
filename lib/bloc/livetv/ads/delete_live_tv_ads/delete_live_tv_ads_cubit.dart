import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'delete_live_tv_ads_state.dart';

class DeleteLiveTvAdsCubit extends Cubit<DeleteLiveTvAdsState> {
  DeleteLiveTvAdsCubit() : super(DeleteLiveTvAdsInitial());

  deleteLiveTvAds(String id) async {
    try {
      emit(DeleteLiveTvAdsLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.liveTvAdsUrl}/$id"),
          headers: headers,
      );
      final result = jsonDecode(response.body.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteLiveTvAdsLoadedState(),
          );
        } else {
          emit(DeleteLiveTvAdsErrorState("${result['message']}"));
        }
      } else {
        emit(DeleteLiveTvAdsErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(DeleteLiveTvAdsErrorState("$e $s"));
    }
  }
}
