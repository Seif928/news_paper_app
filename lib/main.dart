import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/routes/app_router.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/core/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_paper_app/core/service/service_locator.dart'
    as service_locator;
import 'package:news_paper_app/presentation/cubits/favorite/favorite_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await service_locator.initServiceLocator();
  runApp(const NewspapersApp());
}

class NewspapersApp extends StatelessWidget {
  const NewspapersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => service_locator.sl<FavoriteCubit>()..getFavorites(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Newspapers App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        initialRoute: AppRoutes.homePageRoute,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
