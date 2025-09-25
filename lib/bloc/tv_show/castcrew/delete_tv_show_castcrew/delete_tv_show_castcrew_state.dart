part of 'delete_tv_show_castcrew_cubit.dart';

sealed class DeleteTvShowCastcrewState extends Equatable {}

final class DeleteTvShowCastcrewInitial extends DeleteTvShowCastcrewState {
  @override
  List<Object?> get props => [];
}


final class DeleteTvShowCastcrewLoadingState extends DeleteTvShowCastcrewState {
  @override
  List<Object?> get props => [];
}



final class DeleteTvShowCastcrewLoadedState extends DeleteTvShowCastcrewState {
  @override
  List<Object?> get props => [];
}


final class DeleteTvShowCastcrewErrorState extends DeleteTvShowCastcrewState {
  final String error;
  DeleteTvShowCastcrewErrorState(this.error);
  @override
  List<Object?> get props => [];
}
