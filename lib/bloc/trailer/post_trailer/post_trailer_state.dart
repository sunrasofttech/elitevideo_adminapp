part of 'post_trailer_cubit.dart';

sealed class PostTrailerState extends Equatable {}

final class PostTrailerInitial extends PostTrailerState {
  @override
  List<Object?> get props => [];
}

final class PostTrailerLoadingState extends PostTrailerState {
  @override
  List<Object?> get props => [];
}

final class PostTrailerLaodedState extends PostTrailerState {
  @override
  List<Object?> get props => [];
}

final class PostTrailerErrorState extends PostTrailerState {
  final String error;
  PostTrailerErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

final class PostTrailerProgressState extends PostTrailerState {
  final int? percent;
  PostTrailerProgressState({this.percent});
  @override
  List<Object?> get props => [percent];
}
