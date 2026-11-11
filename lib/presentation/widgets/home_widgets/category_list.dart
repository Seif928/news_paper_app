import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/presentation/cubits/news/news_cubit.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int selectedIndex = 0;

  final List<String> categoriesEn = const [
    'All',
    'Business',
    'Entertainment',
    'Health',
    'Science',
    'Sports',
    'Technology',
  ];

  final List<String> categoriesAr = const [
    'الكل',
    'أعمال',
    'ترفيه',
    'صحة',
    'علوم',
    'رياضة',
    'تكنولوجيا',
  ];

  @override
  Widget build(BuildContext context) {
    context.locale;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isArabic = context.locale.languageCode == 'ar';
    final categories = isArabic ? categoriesAr : categoriesEn;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return ChoiceChip(
            label: Text(categories[index]),
            selected: isSelected,
            onSelected: (_) {
              setState(() {
                selectedIndex = index;
              });
              if (index == 0) {
                context.read<NewsCubit>().getTopHeadlines(refresh: true);
              } else {
                context.read<NewsCubit>().getTopHeadlines(
                  category: categoriesEn[index],
                  refresh: true,
                );
              }
            },
            selectedColor: colorScheme.secondary,
            backgroundColor: theme.brightness == Brightness.light
                ? const Color(0xFFE4ECF7)
                : colorScheme.surfaceContainerHighest,
            labelStyle: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (theme.brightness == Brightness.light
                      ? colorScheme.secondary
                      : colorScheme.onSurface),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            side: BorderSide.none,
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}
