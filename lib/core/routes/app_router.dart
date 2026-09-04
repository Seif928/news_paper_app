import 'package:flutter/material.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/domain/entities/article.dart';
import 'package:news_paper_app/presentation/pages/about_page.dart';
import 'package:news_paper_app/presentation/pages/article_details_page.dart';
import 'package:news_paper_app/presentation/pages/favorite_page.dart';
import 'package:news_paper_app/presentation/pages/home_page.dart';
import 'package:news_paper_app/presentation/pages/search_page.dart';
import 'package:news_paper_app/presentation/pages/settings_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.homePageRoute:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.searchPageRoute:
        final autoFocus = settings.arguments as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) => SearchPage(autoFocus: autoFocus),
        );
      case AppRoutes.articleDetailsPageRoute:
        final article = settings.arguments as Article;
        return MaterialPageRoute(
          builder: (_) => ArticleDetailsPage(article: article),
        );
      case AppRoutes.favoritePageRoute:
        return MaterialPageRoute(builder: (_) => const FavoritePage());
      case AppRoutes.settingsPageRoute:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case AppRoutes.aboutPageRoute:
        return MaterialPageRoute(builder: (_) => const AboutPage());
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
