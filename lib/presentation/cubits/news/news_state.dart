import 'package:news_paper_app/domain/entities/article.dart';

sealed class NewsState {
  const NewsState();
}

class NewsInitial extends NewsState {
  const NewsInitial();
}

class NewsLoading extends NewsState {
  const NewsLoading();
}

class NewsLoaded extends NewsState {
  final List<Article> articles;
  final bool hasMore;
  const NewsLoaded(this.articles, {this.hasMore = true});
}

class NewsLoadingMore extends NewsState {
  final List<Article> articles;
  final bool hasMore;

  const NewsLoadingMore(this.articles, {this.hasMore = true});
}

class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);
}
