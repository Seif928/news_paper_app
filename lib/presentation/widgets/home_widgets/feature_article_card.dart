import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/core/utils/date_utils.dart';
import 'package:news_paper_app/domain/entities/article.dart';
import 'package:news_paper_app/presentation/cubits/favorite/saved_cubit.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/article_image.dart';

class FeaturedArticleCard extends StatelessWidget {
  final Article article;
  final EdgeInsetsGeometry? margin;
  final double? imageHeight;

  const FeaturedArticleCard({
    super.key,
    required this.article,
    this.margin,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFavorite = context.watch<SavedCubit>().isSaved(article.url);

    return Padding(
      padding: margin ?? const EdgeInsets.symmetric(horizontal: 16),
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
              imageHeight != null
                  ? SizedBox(
                      height: imageHeight,
                      width: double.infinity,
                      child: ArticleImage(imageUrl: article.imageUrl),
                    )
                  : AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ArticleImage(imageUrl: article.imageUrl),
                    ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              theme.colorScheme.primary,
                          radius: 16,
                          child: Text(
                            article.sourceName.isNotEmpty
                                ? article.sourceName[0].toUpperCase()
                                : '?',
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${article.sourceName}${_publishedText().isNotEmpty ? ' • ${_publishedText()}' : ''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context.read<SavedCubit>().toggleSaved(article);
                          },
                          icon: Icon(
                            isFavorite ? Icons.bookmark : Icons.bookmark_border,
                            color: theme.colorScheme.secondary,
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
