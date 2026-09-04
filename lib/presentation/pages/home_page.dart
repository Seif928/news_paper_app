import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/service/service_locator.dart';

import 'package:news_paper_app/presentation/cubits/news/news_cubit.dart';
import 'package:news_paper_app/presentation/cubits/news/news_state.dart';
import 'package:news_paper_app/presentation/widgets/app_drawer.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/category_list.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/feature_article_card.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/home_header.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/home_search_bar.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/latest_news_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NewsCubit>()..getTopHeadlines(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const HomeHeader(),

                  const SizedBox(height: 20),

                  const HomeSearchBar(),

                  const SizedBox(height: 20),

                  const CategoryList(),

                  const SizedBox(height: 28),
                ]),
              ),
            ),

            BlocBuilder<NewsCubit, NewsState>(
              builder: (context, state) {
                if (state is NewsLoading) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is NewsError) {
                  return SliverFillRemaining(
                    child: Center(child: Text(state.message)),
                  );
                }

                if (state is NewsLoaded) {
                  if (state.articles.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text('No articles found')),
                    );
                  }

                  final articles = state.articles;

                  return SliverList(
                    delegate: SliverChildListDelegate([
                      FeaturedArticleCard(article: articles.first),

                      const SizedBox(height: 32),

                      LatestNewsSection(articles: articles.skip(1).toList()),

                      const SizedBox(height: 20),
                    ]),
                  );
                }

                return const SliverToBoxAdapter(child: SizedBox());
              },
            ),
          ],
        ),
      ),
    );
  }
}
