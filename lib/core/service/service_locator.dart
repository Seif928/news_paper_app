import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_paper_app/core/network/dio_client.dart';
import 'package:news_paper_app/data/datasource/local_data/saved_local_data_source.dart';
import 'package:news_paper_app/data/datasource/local_data/news_local_data_source.dart';
import 'package:news_paper_app/data/datasource/local_data/search_local_data_sorce.dart';
import 'package:news_paper_app/data/datasource/local_data/theme_mode_local_data_source.dart';
import 'package:news_paper_app/data/datasource/remote_data/firebase_remote_data_source.dart';
import 'package:news_paper_app/data/datasource/remote_data/news_api_service.dart';
import 'package:news_paper_app/data/datasource/remote_data/news_remote_data_source.dart';
import 'package:news_paper_app/data/repositories/auth_repository_impl.dart';
import 'package:news_paper_app/data/repositories/saved_repository_impl.dart';
import 'package:news_paper_app/data/repositories/news_repository_impl.dart';
import 'package:news_paper_app/data/repositories/search_repository_impl.dart';
import 'package:news_paper_app/data/repositories/theme_mode_repository_impl.dart';
import 'package:news_paper_app/domain/repositories/base_saved_reposirotry.dart';
import 'package:news_paper_app/domain/repositories/base_newspapers_repository.dart';
import 'package:news_paper_app/domain/repositories/base_search_repository.dart';
import 'package:news_paper_app/domain/repositories/base_theme_mode_repository.dart';
import 'package:news_paper_app/domain/repositories/base_user_repository.dart';
import 'package:news_paper_app/domain/usecases/search/get_everthing_use_case.dart';
import 'package:news_paper_app/domain/usecases/news/get_top_headlines_use_case.dart';
import 'package:news_paper_app/presentation/cubits/auth/auth_cubit.dart';
import 'package:news_paper_app/presentation/cubits/favorite/saved_cubit.dart';
import 'package:news_paper_app/presentation/cubits/news/news_cubit.dart';
import 'package:news_paper_app/presentation/cubits/search/search_cubit.dart';
import 'package:news_paper_app/presentation/cubits/theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  final newsLocalDataSource = NewsLocalDataSource();

  await newsLocalDataSource.init();
  final searchLocalDataSource = SearchLocalDataSource();
  await searchLocalDataSource.init();
  final googleSignIn = GoogleSignIn.instance;
  await googleSignIn.initialize();
  final themeLocalDataSource = ThemeModeLocalDataSource();
  await themeLocalDataSource.init();
  sl.registerLazySingleton<NewsLocalDataSource>(() => newsLocalDataSource);

  sl.registerLazySingleton<DioClient>(() => DioClient());

  sl.registerLazySingleton<NewsApiService>(
    () => NewsApiService(sl<DioClient>()),
  );

  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSource(sl<NewsApiService>()),
  );

  sl.registerLazySingleton<BaseNewspapersRepository>(
    () => NewsRepositoryImpl(
      sl<NewsRemoteDataSource>(),
      sl<NewsLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton<firebase.FirebaseAuth>(
    () => firebase.FirebaseAuth.instance,
  );
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.instance);

  sl.registerLazySingleton<AuthFirebaseDataSource>(
    () => AuthFirebaseDataSource(sl(), sl()),
  );

  sl.registerLazySingleton<BaseAuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerFactory<AuthCubit>(() => AuthCubit(sl()));
  sl.registerLazySingleton<GetTopHeadlinesUseCase>(
    () => GetTopHeadlinesUseCase(sl<BaseNewspapersRepository>()),
  );
  sl.registerLazySingleton<GetEverythingUseCase>(
    () => GetEverythingUseCase(sl<BaseSearchRepository>()),
  );
  sl.registerLazySingleton<SavedLocalDataSource>(() => SavedLocalDataSource());

  sl.registerLazySingleton<BaseSavedRepository>(
    () => SavedRepositoryImpl(sl<SavedLocalDataSource>()),
  );

  sl.registerLazySingleton<SearchLocalDataSource>(
    () => SearchLocalDataSource(),
  );

  sl.registerLazySingleton<BaseSearchRepository>(
    () => SearchRepositoryImpl(
      sl<SearchLocalDataSource>(),
      sl<NewsRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<ThemeModeLocalDataSource>(
    () => ThemeModeLocalDataSource(),
  );

  sl.registerLazySingleton<BaseThemeModeRepository>(
    () => ThemeModeRepositoryImpl(sl<ThemeModeLocalDataSource>()),
  );
  sl.registerFactory<NewsCubit>(() => NewsCubit(sl<GetTopHeadlinesUseCase>()));

  sl.registerFactory<SearchCubit>(
    () => SearchCubit(sl<GetEverythingUseCase>(), sl<BaseSearchRepository>()),
  );

  sl.registerFactory<SavedCubit>(() => SavedCubit(sl<BaseSavedRepository>()));

  sl.registerFactory<ThemeCubit>(
    () => ThemeCubit(sl<BaseThemeModeRepository>()),
  );
}
