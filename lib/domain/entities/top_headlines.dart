import 'package:equatable/equatable.dart';

class TopHeadlines extends Equatable {
  final String? country;
  final String? category;
  final String? sources;
  final String? q;
  final int? pageSize;
  final int? page;

  const TopHeadlines({
    this.country,
    this.q,
    this.sources,
    this.category,
    this.pageSize,
    this.page,
  });

  @override
  List<Object?> get props => [country, category, pageSize, sources, page, q];
}
