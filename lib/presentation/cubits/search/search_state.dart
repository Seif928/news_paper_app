part of 'search_cubit.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Article> articles;
  final int currentPage;
  final int totalPages;

  const SearchLoaded({
    required this.articles,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object> get props => [articles, currentPage, totalPages];
}

class SearchLoadingPage extends SearchState {
  final int page;

  const SearchLoadingPage({required this.page});

  @override
  List<Object> get props => [page];
}

final class RecentSearchesLoaded extends SearchState {
  final List<String> searches;

  const RecentSearchesLoaded({required this.searches});

  @override
  List<Object> get props => [searches];
}

class SearchSuggestionsLoaded extends SearchState {
  final List<String> suggestions;
  const SearchSuggestionsLoaded({required this.suggestions});

  @override
  List<Object> get props => [suggestions];
}

final class SearchError extends SearchState {
  final String message;
  const SearchError({required this.message});
  @override
  List<Object> get props => [message];
}
