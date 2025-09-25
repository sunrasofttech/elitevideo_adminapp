part of 'delete_music_cubit.dart';

sealed class DeleteMusicState extends Equatable {}

final class DeleteMusicInitial extends DeleteMusicState {
  @override
  List<Object?> get props => [];
}

final class DeleteMusicLoadingState extends DeleteMusicState {
  @override
  List<Object?> get props => [];
}

final class DeleteMusicLoadedState extends DeleteMusicState {
  @override
  List<Object?> get props => [];
}

final class DeleteMusicErrorState extends DeleteMusicState {
  final String error;
  DeleteMusicErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
