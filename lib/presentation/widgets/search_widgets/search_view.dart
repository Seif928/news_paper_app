import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/presentation/cubits/search/search_cubit.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/article_card.dart';
import 'package:news_paper_app/presentation/widgets/search_widgets/input_search.dart';
import 'package:news_paper_app/presentation/widgets/search_widgets/recent_searches.dart';
import 'package:news_paper_app/presentation/widgets/search_widgets/trending_topics.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;

  final List<String> _recentSearches = [
    'Climate change',
    'World Cup',
    'AI ethics',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });

    _scrollController.addListener(_onScroll);
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<SearchCubit>().search(query);
    });
  }

  void _performSearch(String query) {
    final trimedQuery = query.trim();

    if (trimedQuery.isEmpty) {
      return;
    }

    context.read<SearchCubit>().search(trimedQuery);
  }

  void _removeRecentSearch(String search) {
    setState(() {
      _recentSearches.remove(search);
    });
  }

  void _clearRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  void _selectTrendingTopic(String topic) {
    _searchController.text = topic;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: _searchController.text.length),
    );
    _performSearch(topic);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 300) {
      context.read<SearchCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
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
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 36)),

            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchInitial) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          RecentSearches(
                            searches: _recentSearches,
                            onClear: _clearRecentSearches,
                            onRemove: _removeRecentSearch,
                            onSelect: (search) {
                              _searchController.text = search;
                            },
                          ),

                          const SizedBox(height: 30),

                          TrendingTopics(onTopicSelected: _selectTrendingTopic),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  );
                }

                if (state is SearchLoading) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                if (state is SearchError) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(child: Text(state.message)),
                    ),
                  );
                }

                if (state is SearchLoaded || state is SearchLoadingMore) {
                  final articles =
                      state is SearchLoaded
                          ? state.articles
                          : (state as SearchLoadingMore).articles;

                  if (articles.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: Text('No articles found')),
                      ),
                    );
                  }

                  final isLoadingMore = state is SearchLoadingMore;

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index == articles.length) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        return ArticleCard(article: articles[index]);
                      }, childCount: articles.length + (isLoadingMore ? 1 : 0)),
                    ),
                  );
                }

                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }
}
