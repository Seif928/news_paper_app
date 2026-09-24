part of 'saved_cubit.dart';

abstract class SavedState extends Equatable {
  const SavedState();

  @override
  List<Object?> get props => [];
}

class SavedInitial extends SavedState {}

class SavedLoading extends SavedState {}

class SavedLoaded extends SavedState {
  final List<Article> articles;

  const SavedLoaded(this.articles);

  @override
  List<Object?> get props => [articles];
}

class SavedError extends SavedState {
  final String message;

  const SavedError(this.message);

  @override
  List<Object?> get props => [message];
}
