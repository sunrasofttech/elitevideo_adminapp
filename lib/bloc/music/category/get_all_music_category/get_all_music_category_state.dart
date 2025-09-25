part of 'get_all_music_category_cubit.dart';

sealed class GetAllMusicCategoryState extends Equatable {}

final class GetAllMusicCategoryInitial extends GetAllMusicCategoryState {
  @override
  List<Object?> get props => [];
}

final class GetAllMusicCategoryLoadingState extends GetAllMusicCategoryState {
  @override
  List<Object?> get props => [];
}

final class GetAllMusicCategoryLoadedState extends GetAllMusicCategoryState {
  final GetAllMusicModel model;
  GetAllMusicCategoryLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllMusicCategoryErrorState extends GetAllMusicCategoryState {
  final String error;
  GetAllMusicCategoryErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
