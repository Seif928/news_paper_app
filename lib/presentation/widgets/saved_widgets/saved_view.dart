import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/utils/responsive.dart';
import 'package:news_paper_app/presentation/cubits/favorite/saved_cubit.dart';
import 'package:news_paper_app/presentation/widgets/responsive/responsive_content.dart';
import 'package:news_paper_app/presentation/widgets/responsive/responsive_page_scaffold.dart';
import 'package:news_paper_app/presentation/widgets/saved_widgets/saved_article_card.dart';

class SavedView extends StatelessWidget {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;
    final size = Responsive.of(context);
    final theme = Theme.of(context);

    final clearButton = BlocBuilder<SavedCubit, SavedState>(
      builder: (context, state) {
        final hasArticles = state is SavedLoaded && state.articles.isNotEmpty;
        if (!hasArticles) return const SizedBox.shrink();

        return TextButton.icon(
          onPressed: () => context.read<SavedCubit>().clearSaved(),
          icon: const Icon(Icons.delete_outline, size: 20),
          label: Text("Clear All".tr()),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.secondary,
          ),
        );
      },
    );

    return ResponsivePageScaffold(
      showDrawer: true,
      compactTitle: Text("Saved".tr()),
      compactActions: [
        clearButton,
        const SizedBox(width: 8),
      ],
      wideTitle: Text("Saved".tr()),
      wideActions: [clearButton],
      maxWidth: LayoutSizes.maxContentWidth,
      body: BlocBuilder<SavedCubit, SavedState>(
        builder: (context, state) {
          if (state is SavedLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SavedError) {
            return Center(child: Text(state.message));
          }

          if (state is SavedLoaded) {
            if (state.articles.isEmpty) {
              return const _EmptyFavorites();
            }

            final articles = state.articles.reversed.toList();

            return ResponsiveContent(
              maxWidth: LayoutSizes.maxContentWidth,
              padding: EdgeInsets.symmetric(
                horizontal: size.isCompact ? 16 : 0,
                vertical: 8,
              ),
              child: size.isCompact
                  ? ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        return SavedArticleCard(article: articles[index]);
                      },
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        final columns = Responsive.columnsFor(
                          width,
                          minItemWidth: 360,
                          spacing: 16,
                          maxColumns: 3,
                        );

                        final rowCount = (articles.length / columns).ceil();
                        return ListView.builder(
                          itemCount: rowCount,
                          itemBuilder: (context, row) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var col = 0; col < columns; col++) ...[
                                    if (col > 0) const SizedBox(width: 16),
                                    Expanded(
                                      child: (row * columns + col < articles.length)
                                          ? SavedArticleCard(
                                              article: articles[row * columns + col],
                                              margin: EdgeInsets.zero,
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    context.locale;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 64,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              "No saved articles".tr(),
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              "Articles you save will appear here.".tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
