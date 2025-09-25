part of 'create_music_cubit.dart';

sealed class CreateMusicState extends Equatable {}

final class CreateMusicInitial extends CreateMusicState {
  @override
  List<Object?> get props => [];
}

final class CreateMusicLoadingState extends CreateMusicState {
  @override
  List<Object?> get props => [];
}

final class CreateMusicLoadedState extends CreateMusicState {
  @override
  List<Object?> get props => [];
}

final class CreateMusicErrorState extends CreateMusicState {
  final String error;
  CreateMusicErrorState(this.error);
  @override
  List<Object?> get props => [error];
}