import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/domain/entities/article.dart';
import 'package:news_paper_app/presentation/cubits/favorite/favorite_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailsPage extends StatelessWidget {
  final Article article;

  const ArticleDetailsPage({super.key, required this.article});

  Future<void> _openArticle() async {
    final uri = Uri.tryParse(article.url);

    if (uri == null) {
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Unknown date';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.watch<FavoriteCubit>().isFavorite(article.url);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(article.sourceName),
        actions: [
          IconButton(
            onPressed: () {
              context.read<FavoriteCubit>().toggleFavorite(article);
            },
            icon: Icon(
              isFavorite ? Icons.bookmark : Icons.bookmark_border,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  const SizedBox(height: 12),

                  _buildArticleInfo(),

                  const SizedBox(height: 20),

                  if (article.description != null &&
                      article.description!.isNotEmpty)
                    Text(
                      article.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),

                  const SizedBox(height: 20),

                  if (article.content != null && article.content!.isNotEmpty)
                    Text(
                      article.content!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _openArticle,
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text('Read Full Article'),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (article.imageUrl == null || article.imageUrl!.isEmpty) {
      return Image.asset(
        'assets/images/Image-not-found.png',
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: article.imageUrl!,
      width: double.infinity,
      height: 250,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) {
        return Image.asset(
          'assets/images/Image-not-found.png',
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildArticleInfo() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              const Icon(Icons.person_outline, size: 18),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  article.author ?? 'Unknown author',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 18),

            const SizedBox(width: 6),

            Text(_formatDate(article.publishedAt)),
          ],
        ),
      ],
    );
  }
}
