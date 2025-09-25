part of 'update_artist_cubit.dart';

sealed class UpdateArtistState extends Equatable {}

final class UpdateArtistInitial extends UpdateArtistState {
  @override
  List<Object?> get props => [];
}

final class UpdateArtistLoadingState extends UpdateArtistState {
  @override
  List<Object?> get props => [];
}

final class UpdateArtistLoadedState extends UpdateArtistState {
  @override
  List<Object?> get props => [];
}

final class UpdateArtistErrorState extends UpdateArtistState {
  final String error;
  UpdateArtistErrorState(this.error);
  @override
  List<Object?> get props => [error];
}