import 'package:get_it/get_it.dart';
import 'package:news_paper_app/core/network/dio_client.dart';
import 'package:news_paper_app/data/datasource/local_data/favorite_local_data_source.dart';
import 'package:news_paper_app/data/datasource/local_data/news_local_data_source.dart';
import 'package:news_paper_app/data/datasource/local_data/search_local_data_sorce.dart';
import 'package:news_paper_app/data/datasource/remote_data/news_api_service.dart';
import 'package:news_paper_app/data/datasource/remote_data/news_remote_data_source.dart';
import 'package:news_paper_app/data/repositories/favorite_repository_impl.dart';
import 'package:news_paper_app/data/repositories/news_repository_impl.dart';
import 'package:news_paper_app/data/repositories/search_repository_impl.dart';
import 'package:news_paper_app/domain/repositories/base_favorite_reposirotry.dart';
import 'package:news_paper_app/domain/repositories/base_newspapers_repository.dart';
import 'package:news_paper_app/domain/repositories/base_search_repository.dart';
import 'package:news_paper_app/domain/usecases/search/get_everthing_use_case.dart';
import 'package:news_paper_app/domain/usecases/news/get_top_headlines_use_case.dart';
import 'package:news_paper_app/presentation/cubits/favorite/favorite_cubit.dart';
import 'package:news_paper_app/presentation/cubits/news/news_cubit.dart';
import 'package:news_paper_app/presentation/cubits/search/search_cubit.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  final newsLocalDataSource = NewsLocalDataSource();

  await newsLocalDataSource.init();
  final searchLocalDataSource = SearchLocalDataSource();
  await searchLocalDataSource.init();

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

  sl.registerLazySingleton<GetTopHeadlinesUseCase>(
    () => GetTopHeadlinesUseCase(sl<BaseNewspapersRepository>()),
  );
  sl.registerLazySingleton<GetEverythingUseCase>(
    () => GetEverythingUseCase(sl<BaseSearchRepository>()),
  );
  sl.registerLazySingleton<FavoriteLocalDataSource>(
    () => FavoriteLocalDataSource(),
  );

  sl.registerLazySingleton<BaseFavoriteRepository>(
    () => FavoriteRepositoryImpl(sl<FavoriteLocalDataSource>()),
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

  sl.registerFactory<NewsCubit>(() => NewsCubit(sl<GetTopHeadlinesUseCase>()));
  sl.registerFactory<SearchCubit>(
    () => SearchCubit(sl<GetEverythingUseCase>(), sl<BaseSearchRepository>()),
  );

  sl.registerFactory<FavoriteCubit>(
    () => FavoriteCubit(sl<BaseFavoriteRepository>()),
  );
}
