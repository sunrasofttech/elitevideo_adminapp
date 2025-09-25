part of 'delete_language_cubit.dart';

sealed class DeleteLanguageState extends Equatable {}

final class DeleteLanguageInitial extends DeleteLanguageState {
  @override
  List<Object?> get props => [];
}


final class DeleteLanguageLoadingState extends DeleteLanguageState {
  @override
  List<Object?> get props => [];
}

final class DeleteLanguageLoadedState extends DeleteLanguageState {
  @override
  List<Object?> get props => [];
}

final class DeleteLanguageErrorState extends DeleteLanguageState {
  final String error;
  DeleteLanguageErrorState(this.error);
  @override
  List<Object?> get props => [error];
}