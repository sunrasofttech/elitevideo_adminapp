import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'delete_live_tv_state.dart';

class DeleteLiveTvCubit extends Cubit<DeleteLiveTvState> {
  DeleteLiveTvCubit() : super(DeleteLiveTvInitial());

  deleteLiveTv(List<String> ids) async {
    try {
      emit(DeleteLiveTvLoadingState());

      String url = AppUrls.liveTvUrl;
      final headers = {
        'Content-Type': 'application/json',
      };

      final body = json.encode({
        "ids": ids,
      });

      // Build cURL log
      final curl = StringBuffer()..write('curl -X DELETE "$url"');
      headers.forEach((key, value) {
        curl.write(' -H "$key: $value"');
      });
      curl.write(" --data-raw '${body.replaceAll("'", r"'\''")}'");

      log('CURL COMMAND:\n$curl');
      var response = await delete(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      final result = jsonDecode(response.body.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteLiveTvLoadedState(),
          );
        } else {
          emit(DeleteLiveTvErrorState("${result['message']}"));
        }
      } else {
        emit(DeleteLiveTvErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(DeleteLiveTvErrorState("$e $s"));
    }
  }
}
