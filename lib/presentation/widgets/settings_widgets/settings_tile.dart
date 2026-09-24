import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;
  final bool isLast;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.trailing,
    this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border:
              isLast
                  ? null
                  : Border(
                    bottom: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.outlineVariant.withOpacity(0.5),
                      width: 0.6,
                    ),
                  ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
