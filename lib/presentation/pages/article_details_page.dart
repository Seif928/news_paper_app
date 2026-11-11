import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/utils/responsive.dart';
import 'package:news_paper_app/domain/entities/article.dart';
import 'package:news_paper_app/presentation/cubits/favorite/saved_cubit.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/article_image.dart';
import 'package:news_paper_app/presentation/widgets/responsive/responsive_content.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailsPage extends StatelessWidget {
  final Article article;

  const ArticleDetailsPage({super.key, required this.article});

  Future<void> _openArticle() async {
    final uri = Uri.tryParse(article.url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown date'.tr();
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    final isFavorite = context.watch<SavedCubit>().isSaved(article.url);
    final size = Responsive.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(article.sourceName),
        actions: [
          IconButton(
            onPressed: () {
              context.read<SavedCubit>().toggleSaved(article);
            },
            icon: Icon(
              isFavorite ? Icons.bookmark : Icons.bookmark_border,
              color: theme.colorScheme.secondary,
            ),
            tooltip: isFavorite ? "Saved".tr() : "Save".tr(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ResponsiveContent(
            maxWidth: LayoutSizes.maxReadingWidth,
            padding: EdgeInsets.symmetric(
              horizontal: size.isCompact ? 16 : 24,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(context),
                const SizedBox(height: 24),
                Text(
                  article.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 16),
                _buildArticleInfo(context),
                const SizedBox(height: 24),
                const Divider(height: 1),
                const SizedBox(height: 24),
                if (article.description != null &&
                    article.description!.trim().isNotEmpty) ...[
                  Text(
                    article.description!.trim(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      fontSize: 17,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                if (article.content != null &&
                    article.content!.trim().isNotEmpty) ...[
                  Text(
                    article.content!.trim(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _openArticle,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.open_in_browser),
                        label: Text(
                          context.locale.languageCode == 'ar'
                              ? 'اقرأ المقال كاملا'
                              : 'Read Full Article',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final size = Responsive.of(context);
    final borderRadius = BorderRadius.circular(size.isCompact ? 16 : 20);

    return AspectRatio(
      aspectRatio: size.isCompact ? (16 / 10) : (16 / 9),
      child: ArticleImage(
        imageUrl: article.imageUrl,
        borderRadius: borderRadius,
      ),
    );
  }

  Widget _buildArticleInfo(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.12),
          child: Icon(
            Icons.person_outline,
            size: 16,
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            context.locale.languageCode == 'ar'
                ? article.author ?? 'غير معروف'
                : article.author ?? 'Unknown author',
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          Icons.calendar_today_outlined,
          size: 15,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Text(
          _formatDate(article.publishedAt),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
