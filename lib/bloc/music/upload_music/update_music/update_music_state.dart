part of 'update_music_cubit.dart';

sealed class UpdateMusicState extends Equatable {}

final class UpdateMusicInitial extends UpdateMusicState {
  @override
  List<Object?> get props => [];
}

final class UpdateMusicLoadingState extends UpdateMusicState {
  @override
  List<Object?> get props => [];
}

final class UpdateMusicLoadedState extends UpdateMusicState {
  @override
  List<Object?> get props => [];
}

final class UpdateMusicErrorState extends UpdateMusicState {
  final String error;
  UpdateMusicErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
