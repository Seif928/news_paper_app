import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/presentation/cubits/search/search_cubit.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/article_card.dart';
import 'package:news_paper_app/presentation/widgets/search_widgets/input_search.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocusNode);

      context.read<SearchCubit>().getRecentSearches();
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
                // Recent Searches
                if (state is RecentSearchesLoaded) {
                  final searches = state.searches;

                  if (searches.isEmpty) {
                    return SliverToBoxAdapter(
                      child: TrendingTopics(
                        onTopicSelected: (value) => _selectTrendingTopic(value),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final search = searches[index];

                      return ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(search),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            context.read<SearchCubit>().removeSearch(search);
                          },
                        ),
                        onTap: () {
                          _searchController.text = search;
                          _performSearch(search);
                        },
                      );
                    }, childCount: searches.length),
                  );
                }

                if (state is SearchLoading) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                // Search Results
                if (state is SearchLoaded) {
                  final articles = state.articles;

                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final article = articles[index];

                      return ArticleCard(article: article);
                    }, childCount: articles.length),
                  );
                }

                // Loading More
                if (state is SearchLoadingMore) {
                  final articles = state.articles;

                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index == articles.length) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      return ArticleCard(article: articles[index]);
                    }, childCount: articles.length + 1),
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
