part of 'update_trailer_cubit.dart';

sealed class UpdateTrailerState extends Equatable {}

final class UpdateTrailerInitial extends UpdateTrailerState {
  @override
  List<Object?> get props => [];
}

final class UpdateTrailerLoadingState extends UpdateTrailerState {
  @override
  List<Object?> get props => [];
}

final class UpdateTrailerLoadedState extends UpdateTrailerState {
  @override
  List<Object?> get props => [];
}

final class UpdateTrailerErrorState extends UpdateTrailerState {
  final String error;
  UpdateTrailerErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

final class UpdateTrailerProgressState extends UpdateTrailerState {
  final int? percent;
  UpdateTrailerProgressState({this.percent});
  @override
  List<Object?> get props => [percent];
}
