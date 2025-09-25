part of 'create_live_category_cubit.dart';

sealed class CreateLiveCategoryState extends Equatable {}

final class CreateLiveCategoryInitial extends CreateLiveCategoryState {
  @override
  List<Object?> get props => [];
}

final class CreateLiveCategoryLoadingState extends CreateLiveCategoryState {
  @override
  List<Object?> get props => [];
}

final class CreateLiveCategoryLoadedState extends CreateLiveCategoryState {
  @override
  List<Object?> get props => [];
}

final class CreateLiveCategoryErrorState extends CreateLiveCategoryState {
  final String error;
  CreateLiveCategoryErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
