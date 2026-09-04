class SearchFilter {
  final String? sortBy;
  final String? language;
  final DateTime? from;
  final DateTime? to;
  final String? sources;

  static const unset = Object();
  const SearchFilter({
    this.sortBy,
    this.language,
    this.from,
    this.to,
    this.sources,
  });

  SearchFilter copyWith({
    Object? sortBy = unset,
    Object? language = unset,
    Object? from = unset,
    Object? to = unset,
    Object? sources = unset,
  }) {
    return SearchFilter(
      sortBy: sortBy == unset ? this.sortBy : sortBy as String?,
      language: language == unset ? this.language : language as String?,
      from: from == unset ? this.from : from as DateTime?,
      to: to == unset ? this.to : to as DateTime?,
      sources: sources == unset ? this.sources : sources as String?,
    );
  }
}
