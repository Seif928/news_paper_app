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

  final categories = const [
    'All',
    'Business',
    'Entertainment',
    'Health',
    'Science',
    'Sports',
    'Technology',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = selectedIndex == index;

          return ChoiceChip(
            label: Text(categories[index]),
            selected: selected,
            onSelected: (_) {
              if (categories[index] == 'All') {
                context.read<NewsCubit>().getTopHeadlines();
                return;
              }
              setState(() {
                selectedIndex = index;
                context.read<NewsCubit>().getTopHeadlines(
                  category: categories[index],
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
        },
      ),
    );
  }
}
