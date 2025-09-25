import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'delete_ads_state.dart';

class DeleteAdsCubit extends Cubit<DeleteAdsState> {
  DeleteAdsCubit() : super(DeleteAdsInitial());

  deleteAds(String id) async {
    try {
      emit(DeleteAdsLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.adsUrl}/$id"),
        headers: headers,
      );
      final result = jsonDecode(response.body.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteAdsLaodedState(),
          );
        } else {
          emit(DeleteAdsErrorState("${result['message']}"));
        }
      } else {
        emit(DeleteAdsErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(DeleteAdsErrorState("$e $s"));
    }
  }
}
