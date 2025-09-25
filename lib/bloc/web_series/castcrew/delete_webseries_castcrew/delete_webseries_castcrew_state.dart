part of 'delete_webseries_castcrew_cubit.dart';

sealed class DeleteWebseriesCastcrewState extends Equatable {}

final class DeleteWebseriesCastcrewInitial extends DeleteWebseriesCastcrewState {
  @override
  List<Object?> get props => [];
}


final class DeleteWebseriesCastcrewLoadingState extends DeleteWebseriesCastcrewState {
  @override
  List<Object?> get props => [];
}



final class DeleteWebseriesCastcrewLoadedState extends DeleteWebseriesCastcrewState {
  @override
  List<Object?> get props => [];
}


final class DeleteWebseriesCastcrewErrorState extends DeleteWebseriesCastcrewState {
  final String error;
  DeleteWebseriesCastcrewErrorState(this.error);
  @override
  List<Object?> get props => [];
}
