part of 'get_all_music_cubit.dart';

sealed class GetAllMusicState extends Equatable {}

final class GetAllMusicInitial extends GetAllMusicState {
  @override
  List<Object?> get props => [];
}

final class GetAllMusicLoadingState extends GetAllMusicState {
  @override
  List<Object?> get props => [];
}

final class GetAllMusicLoadedState extends GetAllMusicState {
  final GetMusicModel model;
  GetAllMusicLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllMusicErrorState extends GetAllMusicState {
  final String error;
  GetAllMusicErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
