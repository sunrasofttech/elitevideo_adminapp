part of 'delete_category_cubit.dart';

sealed class DeleteCategoryState extends Equatable {}

final class DeleteCategoryInitial extends DeleteCategoryState {
  @override
  List<Object?> get props => [];
}

final class DeleteCategoryLoadingState extends DeleteCategoryState {
  @override
  List<Object?> get props => [];
}

final class DeleteCategoryLoadedState extends DeleteCategoryState {
  @override
  List<Object?> get props => [];
}

final class DeleteCategoryErrorState extends DeleteCategoryState {
  final String error;
  DeleteCategoryErrorState(this.error);
  @override
  List<Object?> get props => [error];
}