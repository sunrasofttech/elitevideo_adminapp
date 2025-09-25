part of 'update_category_cubit.dart';

sealed class UpdateCategoryState extends Equatable {}

final class UpdateCategoryInitial extends UpdateCategoryState {
  @override
  List<Object?> get props => [];
}

final class UpdateCategoryLoadingState extends UpdateCategoryState {
  @override
  List<Object?> get props => [];
}

final class UpdateCategoryLoadedState extends UpdateCategoryState {
  @override
  List<Object?> get props => [];
}

final class UpdateCategoryErrorState extends UpdateCategoryState {
  final String error;
  UpdateCategoryErrorState(this.error);
  @override
  List<Object?> get props => [error];
}