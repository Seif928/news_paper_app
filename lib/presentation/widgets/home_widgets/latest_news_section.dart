import 'package:flutter/material.dart';
import 'package:news_paper_app/domain/entities/article.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/latest_news_card.dart';

class LatestNewsSection extends StatelessWidget {
  final List<Article> articles;

  const LatestNewsSection({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Latest News', style: Theme.of(context).textTheme.headlineSmall),

          const SizedBox(height: 18),

          ListView.separated(
            separatorBuilder:
                (context, index) => Divider(
                  color: Colors.black.withValues(alpha: 0.06),
                  thickness: 2,
                ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return LatestNewsCard(article: articles[index]);
            },
          ),
        ],
      ),
    );
  }
}
