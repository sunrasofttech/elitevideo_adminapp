part of 'post_music_category_cubit.dart';

sealed class PostMusicCategoryState extends Equatable {}

final class PostMusicCategoryInitial extends PostMusicCategoryState {
  @override
  List<Object?> get props => [];
}

final class PostMusicCategoryLoadingState extends PostMusicCategoryState {
  @override
  List<Object?> get props => [];
}


final class PostMusicCategoryLoadedState extends PostMusicCategoryState {
  @override
  List<Object?> get props => [];
}


final class PostMusicCategoryErrorState extends PostMusicCategoryState {
  final String error;
  PostMusicCategoryErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
