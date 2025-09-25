part of 'post_artist_cubit.dart';

sealed class PostArtistState extends Equatable {}

final class PostArtistInitial extends PostArtistState {
  @override
  List<Object?> get props => [];
}

final class PostArtistLoadingState extends PostArtistState {
  @override
  List<Object?> get props => [];
}

final class PostArtistLoadedState extends PostArtistState {
  @override
  List<Object?> get props => [];
}

final class PostArtistErrorState extends PostArtistState {
  final String error;
  PostArtistErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
