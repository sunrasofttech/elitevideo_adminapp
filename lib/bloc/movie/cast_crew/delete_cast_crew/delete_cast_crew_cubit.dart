import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'delete_cast_crew_state.dart';

class DeleteCastCrewCubit extends Cubit<DeleteCastCrewState> {
  DeleteCastCrewCubit() : super(DeleteCastCrewInitial());

  deleteCastCrew(String id) async {
    try {
      emit(DeleteCastCrewLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.castCrewUrl}/$id"),
        headers: headers,
      );
      final result = jsonDecode(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteCastCrewLaodedState(),
          );
        } else {
          emit(DeleteCastCrewErrorState("${result['message']}"));
        }
      } else {
        emit(DeleteCastCrewErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(DeleteCastCrewErrorState("$e $s"));
    }
  }
}
