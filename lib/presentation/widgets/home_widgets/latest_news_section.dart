import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:news_paper_app/core/utils/responsive.dart';
import 'package:news_paper_app/domain/entities/article.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/article_card.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/latest_news_card.dart';

class LatestNewsSection extends StatelessWidget {
  final List<Article> articles;

  const LatestNewsSection({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    context.locale;
    final size = Responsive.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.isCompact ? 16 : 0,
            vertical: 8,
          ),
          child: Text(
            "Latest News".tr(),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (size.isCompact)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return LatestNewsCard(
                  article: articles[index],
                  showDivider: index < articles.length - 1,
                );
              },
            ),
          )
        else
          // Tablet / Desktop: Clean responsive card grid that sizes naturally
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final columns = Responsive.columnsFor(
                width,
                minItemWidth: 300,
                spacing: 16,
                maxColumns: 3,
              );

              final rowCount = (articles.length / columns).ceil();
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rowCount,
                itemBuilder: (context, row) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var col = 0; col < columns; col++) ...[
                            if (col > 0) const SizedBox(width: 16),
                            Expanded(
                              child: (row * columns + col < articles.length)
                                  ? ArticleCard(
                                      article: articles[row * columns + col],
                                      margin: EdgeInsets.zero,
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
      ],
    );
  }
}
