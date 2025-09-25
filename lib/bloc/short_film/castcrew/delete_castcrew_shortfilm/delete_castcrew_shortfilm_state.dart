part of 'delete_castcrew_shortfilm_cubit.dart';

sealed class DeleteCastcrewShortfilmState extends Equatable {}

final class DeleteCastcrewShortfilmInitial extends DeleteCastcrewShortfilmState {
  @override
  List<Object?> get props => [];
}


final class DeleteCastcrewShortfilmLoadingState extends DeleteCastcrewShortfilmState {
  @override
  List<Object?> get props => [];
}


final class DeleteCastcrewShortfilmLoadedState extends DeleteCastcrewShortfilmState {
  @override
  List<Object?> get props => [];
}


final class DeleteCastcrewShortfilmErrorState extends DeleteCastcrewShortfilmState {
  final String error;
  DeleteCastcrewShortfilmErrorState(this.error);
  @override
  List<Object?> get props => [error];
}