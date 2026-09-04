import 'package:flutter/material.dart';

class RecentSearches extends StatelessWidget {
  final List<String> searches;
  final VoidCallback onClear;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onSelect;

  const RecentSearches({
    super.key,
    required this.searches,
    required this.onClear,
    required this.onRemove,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Recent Searches', style: theme.textTheme.headlineSmall),

            const Spacer(),

            TextButton(
              onPressed: searches.isEmpty ? null : onClear,
              child: const Text('Clear'),
            ),
          ],
        ),

        const SizedBox(height: 14),

        if (searches.isEmpty)
          Text('No recent searches', style: theme.textTheme.bodyLarge)
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: searches.length,
            separatorBuilder: (_, __) {
              return Divider(
                height: 1,
                color: theme.dividerColor.withValues(alpha: 0.5),
              );
            },
            itemBuilder: (context, index) {
              final search = searches[index];

              return InkWell(
                onTap: () => onSelect(search),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history,
                        size: 24,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.65,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Text(search, style: theme.textTheme.bodyLarge),
                      ),

                      IconButton(
                        onPressed: () => onRemove(search),
                        icon: Icon(
                          Icons.close,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
