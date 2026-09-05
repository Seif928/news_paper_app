part of 'search_cubit.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchLoaded extends SearchState {
  final List<Article> articles;
  final bool hasMore;
  const SearchLoaded({required this.articles, required this.hasMore});
  @override
  List<Object> get props => [articles, hasMore];
}

final class SearchLoadingMore extends SearchState {
  final List<Article> articles;
  final bool hasMore;
  const SearchLoadingMore({required this.articles, required this.hasMore});
  @override
  List<Object> get props => [articles, hasMore];
}

final class RecentSearchesLoaded extends SearchState {
  final List<String> searches;

  const RecentSearchesLoaded({required this.searches});

  @override
  List<Object> get props => [searches];
}

final class SearchError extends SearchState {
  final String message;
  const SearchError({required this.message});
  @override
  List<Object> get props => [message];
}
