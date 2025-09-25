part of 'post_language_cubit.dart';

sealed class PostLanguageState extends Equatable {}

final class PostLanguageInitial extends PostLanguageState {
  @override
  List<Object?> get props => [];
}

final class PostLanguageLoadingState extends PostLanguageState {
  @override
  List<Object?> get props => [];
}

final class PostLanguageLoadedState extends PostLanguageState {
  @override
  List<Object?> get props => [];
}

final class PostLanguageErrorState extends PostLanguageState {
  final String error;
  PostLanguageErrorState(this.error);
  @override
  List<Object?> get props => [error];
}