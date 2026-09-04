import 'package:flutter/material.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).pushNamed(AppRoutes.searchPageRoute, arguments: true);
      },
      child: TextField(
        enabled: false,
        decoration: InputDecoration(
          hintText: 'Search news, topics, or sources...',
          prefixIcon: const Icon(Icons.search),
          hintStyle: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
