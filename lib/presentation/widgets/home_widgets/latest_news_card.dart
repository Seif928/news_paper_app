import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/domain/entities/article.dart';

import 'package:news_paper_app/presentation/cubits/favorite/favorite_cubit.dart';

class LatestNewsCard extends StatelessWidget {
  final Article article;

  const LatestNewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isFavorite = context.watch<FavoriteCubit>().isFavorite(article.url);

    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).pushNamed(AppRoutes.articleDetailsPageRoute, arguments: article);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 125,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        article.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            article.sourceName,
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
            ),

            const SizedBox(width: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CachedNetworkImage(
                imageUrl: article.imageUrl!,
                width: 125,
                height: 125,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) {
                  return Image.asset(
                    'assets/images/Image-not-found.png',
                    width: 125,
                    height: 125,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
