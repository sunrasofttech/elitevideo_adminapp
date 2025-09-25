part of 'delete_music_category_cubit.dart';

sealed class DeleteMusicCategoryState extends Equatable {}

final class DeleteMusicCategoryInitial extends DeleteMusicCategoryState {
  @override
  List<Object?> get props => [];
}

final class DeleteMusicCategoryLoadingState extends DeleteMusicCategoryState {
  @override
  List<Object?> get props => [];
}


final class DeleteMusicCategoryLoadedState extends DeleteMusicCategoryState {
  @override
  List<Object?> get props => [];
}


final class DeleteMusicCategoryErrorState extends DeleteMusicCategoryState {
  final String error;
  DeleteMusicCategoryErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
