import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:news_paper_app/core/routes/app_router.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/core/theme/app_theme.dart';
import 'package:news_paper_app/core/utils/responsive.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_paper_app/core/service/service_locator.dart'
    as service_locator;
import 'package:news_paper_app/firebase_options.dart';
import 'package:news_paper_app/presentation/cubits/auth/auth_cubit.dart';
import 'package:news_paper_app/presentation/cubits/country/country_cubit.dart';
import 'package:news_paper_app/presentation/cubits/favorite/saved_cubit.dart';
import 'package:news_paper_app/presentation/cubits/theme/theme_cubit.dart';
import 'package:news_paper_app/core/service/notification_service.dart';
import 'package:timezone/timezone.dart' as tzl;
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tzl.setLocalLocation(tzl.getLocation('Africa/Cairo'));
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await EasyLocalization.ensureInitialized();
  await service_locator.initServiceLocator();
  await Hive.initFlutter();
  await Hive.openBox('app_settings');
  await NotificationService().initialize();
  debugPrint('Before scheduling reminder');
  await NotificationService().scheduleInactivityReminder();
  debugPrint('After scheduling reminder');

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
        BlocProvider<CountryCubit>(
          create: (_) => service_locator.sl<CountryCubit>()..initialize(),
        ),
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
            // Allow mouse / trackpad drag on horizontal lists (Web & desktop).
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
                PointerDeviceKind.stylus,
              },
            ),
            // Scale the type hierarchy to the window size class.
            builder: (context, child) {
              return Theme(
                data: AppTheme.adaptive(
                  Theme.of(context),
                  Responsive.of(context),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
