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
  late int selectedIndex;
  @override
  void initState() {
    selectedIndex = 0;
    super.initState();
  }

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

    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categoriesEn.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          bool selected = selectedIndex == index;
          if (Theme.of(context).brightness == Brightness.light) {
            return ChoiceChip(
              label: Text(
                context.locale == const Locale('ar')
                    ? categoriesAr[index]
                    : categoriesEn[index],
              ),
              selected: selected,
              onSelected: (_) {
                if (categoriesEn[index] == 'All' ||
                    categoriesAr[index] == 'الكل') {
                  context.read<NewsCubit>().getTopHeadlines();
                  return;
                }
                setState(() {
                  selectedIndex = index;
                  context.read<NewsCubit>().getTopHeadlines(
                    category: categoriesEn[index],
                  );
                });
              },
              selectedColor: colorScheme.secondary,
              backgroundColor: const Color(0xFFE4ECF7),
              labelStyle: TextStyle(
                color: selected ? Colors.white : colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
              side: BorderSide.none,
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            );
          }
          return ChoiceChip(
            label: Text(
              context.locale == const Locale('ar')
                  ? categoriesAr[index]
                  : categoriesEn[index],
            ),
            selected: selected,
            onSelected: (_) {
              if (categoriesEn[index] == 'All' ||
                  categoriesAr[index] == 'الكل') {
                context.read<NewsCubit>().getTopHeadlines();
                return;
              }
              setState(() {
                selectedIndex = index;
                context.read<NewsCubit>().getTopHeadlines(
                  category: categoriesEn[index],
                );
              });
            },
            selectedColor: colorScheme.onPrimary,
            backgroundColor: const Color(0xFFE4ECF7),
            labelStyle: TextStyle(
              color: selected ? Colors.white : colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
            side: BorderSide.none,
            showCheckmark: false,

            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          );
        },
      ),
    );
  }
}
