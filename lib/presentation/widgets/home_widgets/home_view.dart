import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/utils/responsive.dart';
import 'package:news_paper_app/presentation/cubits/news/news_cubit.dart';
import 'package:news_paper_app/presentation/cubits/news/news_state.dart';
import 'package:news_paper_app/presentation/widgets/app_drawer.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/category_list.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/feature_article_card.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/home_header.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/home_search_bar.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/latest_news_section.dart';
import 'package:news_paper_app/presentation/widgets/responsive/responsive_content.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;
    final size = Responsive.of(context);

    return Scaffold(
      drawer: size.isCompact ? const AppDrawer() : null,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<NewsCubit>().getTopHeadlines(refresh: true);
          },
          child: CustomScrollView(
            slivers: [
              ResponsiveSliverPadding(
                top: size.isCompact ? 16 : 24,
                bottom: 16,
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeHeader(),
                      if (size.isCompact) ...[
                        const SizedBox(height: 20),
                        const HomeSearchBar(),
                      ],
                      const SizedBox(height: 20),
                      const CategoryList(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              BlocBuilder<NewsCubit, NewsState>(
                builder: (context, state) {
                  if (state is NewsLoading) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state is NewsError) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                              const SizedBox(height: 12),
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<NewsCubit>().getTopHeadlines(refresh: true);
                                },
                                child: Text('Retry'.tr()),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is NewsLoaded) {
                    if (state.articles.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: Text('No articles found'.tr())),
                      );
                    }

                    final articles = state.articles;
                    final firstArticle = articles.first;
                    final remainingArticles = articles.skip(1).toList();

                    return ResponsiveSliverPadding(
                      bottom: 48,
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FeaturedArticleCard(
                              article: firstArticle,
                              margin: size.isCompact
                                  ? EdgeInsets.zero
                                  : EdgeInsets.zero,
                              imageHeight: size.isCompact
                                  ? null
                                  : (size.isLarge ? 380 : 320),
                            ),
                            if (remainingArticles.isNotEmpty) ...[
                              const SizedBox(height: 32),
                              LatestNewsSection(
                                articles: remainingArticles,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }

                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
