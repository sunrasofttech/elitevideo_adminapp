part of 'post_category_cubit.dart';

sealed class PostCategoryState extends Equatable {}

final class PostCategoryInitial extends PostCategoryState {
  @override
  List<Object?> get props => [];
}

final class PostCategoryLoadingState extends PostCategoryState {
  @override
  List<Object?> get props => [];
}


final class PostCategoryErrorState extends PostCategoryState {
  final String error;
  PostCategoryErrorState(this.error);
  @override
  List<Object?> get props => [error];
}


final class PostCategoryLoadedState extends PostCategoryState {
  @override
  List<Object?> get props => [];
}
