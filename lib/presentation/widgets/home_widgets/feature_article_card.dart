import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/core/theme/app_theme.dart';
import 'package:news_paper_app/core/utils/date_utils.dart';
import 'package:news_paper_app/domain/entities/article.dart';

import 'package:news_paper_app/presentation/cubits/favorite/favorite_cubit.dart';

class FeaturedArticleCard extends StatelessWidget {
  final Article article;

  const FeaturedArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isFavorite = context.watch<FavoriteCubit>().isFavorite(article.url);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(
            context,
          ).pushNamed(AppRoutes.articleDetailsPageRoute, arguments: article);
        },
        child: Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: article.imageUrl!,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) {
                  return Image.asset(
                    'assets/images/Image-not-found.png',
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  );
                },
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineSmall,
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          radius: 16,
                          child: Text(
                            article.sourceName.isNotEmpty
                                ? article.sourceName[0].toUpperCase()
                                : '?',
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: AppTheme.backgroundColor,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Text(
                            '${article.sourceName} • '
                            '${_publishedText()}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            context.read<FavoriteCubit>().toggleFavorite(
                              article,
                            );
                          },
                          icon: Icon(
                            color: Theme.of(context).colorScheme.secondary,
                            isFavorite ? Icons.bookmark : Icons.bookmark_border,
                          ),
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

  String _publishedText() {
    if (article.publishedAt == null) {
      return '';
    }

    return DateUtilsApp.formatDate(article.publishedAt) ?? '';
  }
}
