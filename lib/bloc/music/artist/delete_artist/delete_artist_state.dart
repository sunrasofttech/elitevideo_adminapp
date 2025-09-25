part of 'delete_artist_cubit.dart';

sealed class DeleteArtistState extends Equatable {}

final class DeleteArtistInitial extends DeleteArtistState {
  @override
  List<Object?> get props => [];
}

final class DeleteArtistLoadingState extends DeleteArtistState {
  @override
  List<Object?> get props => [];
}

final class DeleteArtistLoadedState extends DeleteArtistState {
  @override
  List<Object?> get props => [];
}

final class DeleteArtistErrorState extends DeleteArtistState {
  final String error;
  DeleteArtistErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
