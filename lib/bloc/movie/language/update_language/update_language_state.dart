part of 'update_language_cubit.dart';

sealed class UpdateLanguageState extends Equatable {}

final class UpdateLanguageInitial extends UpdateLanguageState {
  @override
  List<Object?> get props => [];
}

final class UpdateLanguageLoadingState extends UpdateLanguageState {
  @override
  List<Object?> get props => [];
}

final class UpdateLanguageLoadedState extends UpdateLanguageState {
  @override
  List<Object?> get props => [];
}

final class UpdateLanguageErrorState extends UpdateLanguageState {
  final String error;
  UpdateLanguageErrorState(this.error);
  @override
  List<Object?> get props => [error];
}