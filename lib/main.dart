import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:news_paper_app/core/routes/app_router.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/core/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_paper_app/core/service/service_locator.dart'
    as service_locator;
import 'package:news_paper_app/presentation/cubits/auth/auth_cubit.dart';
import 'package:news_paper_app/presentation/cubits/favorite/saved_cubit.dart';
import 'package:news_paper_app/presentation/cubits/theme/theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await service_locator.initServiceLocator();
  await Hive.initFlutter();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: const NewspapersApp(),
    ),
  );
}

class NewspapersApp extends StatelessWidget {
  const NewspapersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => service_locator.sl<SavedCubit>()..getSaved(),
        ),
        BlocProvider(create: (_) => service_locator.sl<ThemeCubit>()),
        BlocProvider(create: (_) => service_locator.sl<AuthCubit>()),
      ],

      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Newspapers App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            initialRoute: AppRoutes.loginPageRoute,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
