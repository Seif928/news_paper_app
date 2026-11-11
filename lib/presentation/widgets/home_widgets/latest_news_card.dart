import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/core/utils/date_utils.dart';
import 'package:news_paper_app/domain/entities/article.dart';
import 'package:news_paper_app/presentation/cubits/favorite/saved_cubit.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/article_image.dart';

class LatestNewsCard extends StatelessWidget {
  final Article article;
  final bool showDivider;

  const LatestNewsCard({
    super.key,
    required this.article,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFavorite = context.watch<SavedCubit>().isSaved(article.url);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.of(
          context,
        ).pushNamed(AppRoutes.articleDetailsPageRoute, arguments: article);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        article.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${article.sourceName}${_publishedText().isNotEmpty ? ' • ${_publishedText()}' : ''}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          IconButton(
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            onPressed: () {
                              context.read<SavedCubit>().toggleSaved(article);
                            },
                            icon: Icon(
                              isFavorite ? Icons.bookmark : Icons.bookmark_border,
                              color: theme.colorScheme.secondary,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                ArticleImage(
                  imageUrl: article.imageUrl,
                  width: 110,
                  height: 110,
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
            if (showDivider)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _publishedText() {
    if (article.publishedAt == null) {
      return '';
    }
    return DateUtilsApp.formatDate(article.publishedAt) ?? '';
  }
}
