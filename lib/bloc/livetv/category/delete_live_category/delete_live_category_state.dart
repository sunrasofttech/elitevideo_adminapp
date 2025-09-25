part of 'delete_live_category_cubit.dart';

sealed class DeleteLiveCategoryState extends Equatable {}

final class DeleteLiveCategoryInitial extends DeleteLiveCategoryState {
  @override
  List<Object?> get props => [];
}

final class DeleteLiveCategoryLoadingState extends DeleteLiveCategoryState {
  @override
  List<Object?> get props => [];
}

final class DeleteLiveCategoryLoadedState extends DeleteLiveCategoryState {
  @override
  List<Object?> get props => [];
}

final class DeleteLiveCategoryErrorState extends DeleteLiveCategoryState {
  final String error;
  DeleteLiveCategoryErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
