import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageSelected;
  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    context.locale;
    final colorScheme = Theme.of(context).colorScheme;
    final start = (currentPage - 2).clamp(1, totalPages);
    final end = (currentPage + 2).clamp(1, totalPages);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed:
                currentPage > 1 ? () => onPageSelected(currentPage - 1) : null,
          ),
          for (int page = start; page <= end; page++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () => onPageSelected(page),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        page == currentPage
                            ? colorScheme.secondary
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    PaginationNumberFormatter.format(
                      page,
                      context.locale.languageCode,
                    ),
                    style: TextStyle(
                      color: page == currentPage ? Colors.white : null,
                      fontWeight:
                          page == currentPage
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed:
                currentPage < totalPages
                    ? () => onPageSelected(currentPage + 1)
                    : null,
          ),
        ],
      ),
    );
  }
}

class PaginationNumberFormatter {
  PaginationNumberFormatter._();

  static const _arabicDigits = [
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩',
    '١٠',
  ];

  static String format(int number, String languageCode) {
    final numberStr = number.toString();

    if (languageCode != 'ar') {
      return numberStr;
    }

    return numberStr.split('').map((char) {
      final digit = int.tryParse(char);
      return digit != null ? _arabicDigits[digit] : char;
    }).join();
  }
}
