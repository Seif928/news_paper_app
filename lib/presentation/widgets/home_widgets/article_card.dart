import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/core/utils/date_utils.dart';
import 'package:news_paper_app/domain/entities/article.dart';
import 'package:news_paper_app/presentation/cubits/favorite/saved_cubit.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/article_image.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final EdgeInsetsGeometry? margin;

  const ArticleCard({
    super.key,
    required this.article,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.watch<SavedCubit>().isSaved(article.url);
    final theme = Theme.of(context);

    return Card(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.of(
            context,
          ).pushNamed(AppRoutes.articleDetailsPageRoute, arguments: article);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ArticleImage(
                imageUrl: article.imageUrl,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          article.sourceName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (article.publishedAt != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          DateUtilsApp.formatDate(article.publishedAt)!,
                          style: theme.textTheme.labelMedium,
                        ),
                      ],
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        onPressed: () {
                          context.read<SavedCubit>().toggleSaved(article);
                        },
                        icon: Icon(
                          isFavorite
                              ? Icons.bookmark
                              : Icons.bookmark_outline_rounded,
                          color: theme.colorScheme.secondary,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (article.description != null &&
                      article.description!.trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      article.description!.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
