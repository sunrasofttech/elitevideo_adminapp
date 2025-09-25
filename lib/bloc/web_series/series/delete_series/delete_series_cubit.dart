import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'delete_series_state.dart';

class DeleteSeriesCubit extends Cubit<DeleteSeriesState> {
  DeleteSeriesCubit() : super(DeleteSeriesInitial());

  deleteSeries(List<String> id) async {
    try {
      emit(DeleteSeriesLoadingState());
      var response = await delete(
        Uri.parse(AppUrls.seriesUrl),
        body: json.encode({
          "ids": id,
        }),
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteSeriesLoadedState(),
          );
        } else {
          emit(DeleteSeriesErrorState(result["message"]));
        }
      } else {
        emit(DeleteSeriesErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        DeleteSeriesErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
