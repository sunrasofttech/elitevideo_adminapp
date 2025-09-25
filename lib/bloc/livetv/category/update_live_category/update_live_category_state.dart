part of 'update_live_category_cubit.dart';

sealed class UpdateLiveCategoryState extends Equatable {}

final class UpdateLiveCategoryInitial extends UpdateLiveCategoryState {
  @override
  List<Object?> get props => [];
}

final class UpdateLiveCategoryLoadingState extends UpdateLiveCategoryState {
  @override
  List<Object?> get props => [];
}


final class UpdateLiveCategoryLoadedState extends UpdateLiveCategoryState {
  @override
  List<Object?> get props => [];
}


final class UpdateLiveCategoryErrorState extends UpdateLiveCategoryState {
  final String error;
  UpdateLiveCategoryErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
