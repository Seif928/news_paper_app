import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/core/utils/date_utils.dart';
import 'package:news_paper_app/domain/entities/article.dart';
import 'package:news_paper_app/presentation/cubits/favorite/favorite_cubit.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.watch<FavoriteCubit>().isFavorite(article.url);

    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).pushNamed(AppRoutes.articleDetailsPageRoute, arguments: article);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      article.imageUrl ?? 'assets/images/Image-not-found.png',
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return Image.asset(
                      'assets/images/Image-not-found.png',
                      width: double.infinity,
                      height: 100,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        article.sourceName,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),

                      const Spacer(),

                      if (article.publishedAt != null)
                        Text(
                          DateUtilsApp.formatDate(article.publishedAt)!,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),

                      IconButton(
                        onPressed: () {
                          context.read<FavoriteCubit>().toggleFavorite(article);
                        },
                        icon: Icon(
                          isFavorite
                              ? Icons.bookmark
                              : Icons.bookmark_outline_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),

                  Text(
                    article.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  if (article.description != null) ...[
                    const SizedBox(height: 8),

                    Text(
                      article.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
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
