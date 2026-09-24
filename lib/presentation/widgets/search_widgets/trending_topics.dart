import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TrendingTopics extends StatefulWidget {
  final ValueChanged<String>? onTopicSelected;

  const TrendingTopics({super.key, this.onTopicSelected});

  @override
  State<TrendingTopics> createState() => _TrendingTopicsState();
}

class _TrendingTopicsState extends State<TrendingTopics> {
  int selectedIndex = -1;

  final List<String> topicsEn = const [
    'Technology',
    'Global Economy',
    'AI',
    'Climate',
    'Sports',
    'World Cup',
  ];

  final List<String> topicsAr = const [
    'تكنولوجيا',
    'اقتصاد عالمي',
    'ذكاء اصطناعي',
    'مناخ',
    'رياضة',
    'كأس العالم',
  ];
  @override
  Widget build(BuildContext context) {
    context.locale;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.trending_up,
              color: theme.colorScheme.secondary,
              size: 26,
            ),

            const SizedBox(width: 10),

            Text('Trending Topics'.tr(), style: theme.textTheme.headlineSmall),
          ],
        ),

        const SizedBox(height: 16),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(topicsEn.length, (index) {
            final isSelected = selectedIndex == index;

            return ChoiceChip(
              label: Text(
                context.locale == const Locale('ar')
                    ? topicsAr[index]
                    : topicsEn[index],
              ),
              selected: isSelected,
              showCheckmark: false,

              onSelected: (_) {
                setState(() {
                  selectedIndex = isSelected ? -1 : index;
                });

                widget.onTopicSelected?.call(topicsEn[index]);
              },

              selectedColor: theme.colorScheme.secondary.withValues(
                alpha: 0.12,
              ),

              backgroundColor: theme.colorScheme.surface,

              side: BorderSide(
                color:
                    isSelected
                        ? theme.colorScheme.secondary
                        : theme.colorScheme.outline.withValues(alpha: 0.15),
              ),

              labelStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),

              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            );
          }),
        ),
      ],
    );
  }
}
