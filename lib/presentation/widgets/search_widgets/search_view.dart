import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/presentation/cubits/search/search_cubit.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/article_card.dart';
import 'package:news_paper_app/presentation/widgets/search_widgets/input_search.dart';
import 'package:news_paper_app/presentation/widgets/search_widgets/pagination_bar.dart';
import 'package:news_paper_app/presentation/widgets/search_widgets/search_filter_sheet.dart';
import 'package:news_paper_app/presentation/widgets/search_widgets/trending_topics.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocusNode);

      context.read<SearchCubit>().getRecentSearches();
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    if (query.isEmpty) {
      context.read<SearchCubit>().getRecentSearches();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 200), () {
      context.read<SearchCubit>().getSuggestions(query);
    });
  }

  void _performSearch(String query) {
    final trimedQuery = query.trim();

    if (trimedQuery.isEmpty) {
      return;
    }
    _debounce?.cancel();

    context.read<SearchCubit>().search(trimedQuery);
  }

  void _selectTrendingTopic(String topic) {
    _searchController.text = topic.tr();
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: _searchController.text.length),
    );
    _performSearch(topic);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _searchController,
                  builder: (context, value, _) {
                    return Row(
                      children: [
                        Expanded(
                          child: InputSearch(
                            focusNode: _searchFocusNode,
                            controller: _searchController,
                            onChanged: _onSearchChanged,
                            autoFocus: true,
                            onBack: () {
                              Navigator.of(
                                context,
                              ).pushReplacementNamed(AppRoutes.homePageRoute);
                            },
                            onSubmitted: (query) {
                              _searchFocusNode.unfocus();
                              _performSearch(query);
                            },
                            onTaped: (query) {
                              _searchFocusNode.unfocus();
                              _performSearch(query);
                            },
                            suffixIconOnPressed: (query) {
                              _searchController.clear();
                              context.read<SearchCubit>().getRecentSearches();
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.tune),
                          onPressed:
                              value.text.trim().isNotEmpty
                                  ? () => SearchFilterSheet.show(context)
                                  : null,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 36)),

            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is RecentSearchesLoaded) {
                  final searches = state.searches;

                  return SliverMainAxisGroup(
                    slivers: [
                      if (searches.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recent Searches'.tr(),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                TextButton(
                                  onPressed:
                                      () =>
                                          context
                                              .read<SearchCubit>()
                                              .clearSearches(),
                                  child: Text('Clear'.tr()),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final search = searches[index];
                            return ListTile(
                              leading: const Icon(Icons.history),
                              title: Text(search.tr()),
                              trailing: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed:
                                    () => context
                                        .read<SearchCubit>()
                                        .removeSearch(search),
                              ),
                              onTap: () {
                                _searchController.text = search;
                                _performSearch(search);
                              },
                            );
                          }, childCount: searches.length),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 24)),
                      ],

                      SliverPadding(
                        padding: const EdgeInsets.only(
                          bottom: 16,
                          left: 8,
                          right: 8,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: TrendingTopics(
                            onTopicSelected:
                                (value) => _selectTrendingTopic(value),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                if (state is SearchSuggestionsLoaded) {
                  final suggestions = state.suggestions;

                  if (suggestions.isEmpty) {
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final suggestion = suggestions[index];
                      return ListTile(
                        leading: const Icon(Icons.search),
                        title: Text(suggestion),
                        onTap: () {
                          _searchController.text = suggestion;
                          _searchFocusNode.unfocus();
                          _performSearch(suggestion);
                        },
                      );
                    }, childCount: suggestions.length),
                  );
                }

                if (state is SearchLoadingPage) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }
                if (state is SearchLoading) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is SearchLoaded) {
                  final articles = state.articles;

                  return SliverMainAxisGroup(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              ArticleCard(article: articles[index]),
                          childCount: articles.length,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child:
                            articles.isNotEmpty
                                ? PaginationBar(
                                  currentPage: state.currentPage,
                                  totalPages: state.totalPages,
                                  onPageSelected:
                                      (page) => context
                                          .read<SearchCubit>()
                                          .goToPage(page),
                                )
                                : Center(
                                  child: Text(
                                    'No articles found'.tr(),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                      ),
                    ],
                  );
                }

                if (state is SearchError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.only(
                    right: 24,
                    left: 24,
                    bottom: 16,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: TrendingTopics(
                      onTopicSelected: (value) => _selectTrendingTopic(value),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
