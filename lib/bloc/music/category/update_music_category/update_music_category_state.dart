part of 'update_music_category_cubit.dart';

sealed class UpdateMusicCategoryState extends Equatable {}

final class UpdateMusicCategoryInitial extends UpdateMusicCategoryState {
  @override
  List<Object?> get props => [];
}

final class UpdateMusicCategoryLoadedState extends UpdateMusicCategoryState {
  @override
  List<Object?> get props => [];
}

final class UpdateMusicCategoryLoadingState extends UpdateMusicCategoryState {
  @override
  List<Object?> get props => [];
}

final class UpdateMusicCategoryErrorState extends UpdateMusicCategoryState {
  final String error;
  UpdateMusicCategoryErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
