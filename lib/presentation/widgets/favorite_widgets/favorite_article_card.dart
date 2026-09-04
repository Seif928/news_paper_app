import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/core/utils/date_utils.dart';
import 'package:news_paper_app/domain/entities/article.dart';
import 'package:news_paper_app/presentation/cubits/favorite/favorite_cubit.dart';

class FavoriteArticleCard extends StatelessWidget {
  final Article article;

  const FavoriteArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.of(
            context,
          ).pushNamed(AppRoutes.articleDetailsPageRoute, arguments: article);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _ArticleImage(imageUrl: article.imageUrl),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.sourceName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      article.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _dateText(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            context.read<FavoriteCubit>().toggleFavorite(
                              article,
                            );
                          },
                          icon: const Icon(Icons.bookmark),
                          color: theme.colorScheme.secondary,
                          tooltip: 'Remove from favorites',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _dateText() {
    if (article.publishedAt == null) {
      return '';
    }

    return DateUtilsApp.formatDate(article.publishedAt) ?? '';
  }
}

class _ArticleImage extends StatelessWidget {
  final String? imageUrl;

  const _ArticleImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) {
          return Image.asset(
            'assets/images/Image-not-found.png',
            width: 110,
            height: 110,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
