import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/core/utils/responsive.dart';
import 'package:news_paper_app/presentation/cubits/search/search_cubit.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/article_card.dart';
import 'package:news_paper_app/presentation/widgets/responsive/responsive_content.dart';
import 'package:news_paper_app/presentation/widgets/responsive/sliver_responsive_grid.dart';
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
    if (trimedQuery.isEmpty) return;
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
    final size = Responsive.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            ResponsiveSliverPadding(
              top: 16,
              bottom: 16,
              maxWidth: LayoutSizes.maxContentWidth,
              sliver: SliverToBoxAdapter(
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
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              } else {
                                Navigator.of(context).pushReplacementNamed(
                                  AppRoutes.homePageRoute,
                                );
                              }
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
                        const SizedBox(width: 8),
                        IconButton.filledTonal(
                          icon: const Icon(Icons.tune),
                          tooltip: 'Filter'.tr(),
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
            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is RecentSearchesLoaded) {
                  final searches = state.searches;
                  return ResponsiveSliverPadding(
                    maxWidth: LayoutSizes.maxListWidth,
                    bottom: 24,
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        if (searches.isNotEmpty) ...[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Recent Searches'.tr(),
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => context.read<SearchCubit>().clearSearches(),
                                    child: Text('Clear'.tr()),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                              final search = searches[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.history),
                                title: Text(search.tr()),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => context.read<SearchCubit>().removeSearch(search),
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
                        SliverToBoxAdapter(
                          child: TrendingTopics(
                            onTopicSelected: (value) => _selectTrendingTopic(value),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is SearchSuggestionsLoaded) {
                  final suggestions = state.suggestions;
                  if (suggestions.isEmpty) {
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  }
                  return ResponsiveSliverPadding(
                    maxWidth: LayoutSizes.maxListWidth,
                    sliver: SliverList(
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
                    ),
                  );
                }

                if (state is SearchLoadingPage || state is SearchLoading) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is SearchLoaded) {
                  final articles = state.articles;
                  if (articles.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'No articles found'.tr(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    );
                  }

                  return ResponsiveSliverPadding(
                    maxWidth: LayoutSizes.maxContentWidth,
                    bottom: 32,
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        if (size.isCompact)
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => ArticleCard(
                                article: articles[index],
                                margin: const EdgeInsets.only(bottom: 12),
                              ),
                              childCount: articles.length,
                            ),
                          )
                        else
                          SliverResponsiveGrid(
                            itemCount: articles.length,
                            minItemWidth: 320,
                            maxColumns: 4,
                            itemBuilder: (context, index) => ArticleCard(
                              article: articles[index],
                              margin: EdgeInsets.zero,
                            ),
                          ),
                        SliverToBoxAdapter(
                          child: PaginationBar(
                            currentPage: state.currentPage,
                            totalPages: state.totalPages,
                            onPageSelected: (page) =>
                                context.read<SearchCubit>().goToPage(page),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is SearchError) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
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

                return ResponsiveSliverPadding(
                  maxWidth: LayoutSizes.maxListWidth,
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
