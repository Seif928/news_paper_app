import 'package:get_it/get_it.dart';
import 'package:news_paper_app/core/network/dio_client.dart';
import 'package:news_paper_app/data/datasource/local_data/favorite_local_data_source.dart';
import 'package:news_paper_app/data/datasource/local_data/news_local_data_source.dart';
import 'package:news_paper_app/data/datasource/remote_data/news_api_service.dart';
import 'package:news_paper_app/data/datasource/remote_data/news_remote_data_source.dart';
import 'package:news_paper_app/data/repositories/favorite_repository_impl.dart';
import 'package:news_paper_app/data/repositories/news_repository_impl.dart';
import 'package:news_paper_app/domain/repositories/base_favorite_reposirotry.dart';
import 'package:news_paper_app/domain/repositories/base_newspapers_repository.dart';
import 'package:news_paper_app/domain/usecases/favorite/AddFavoriteUseCase.dart';
import 'package:news_paper_app/domain/usecases/favorite/GetFavoritesUseCase.dart';
import 'package:news_paper_app/domain/usecases/favorite/RemoveFavoriteUseCase.dart';
import 'package:news_paper_app/domain/usecases/news/get_everthing_use_case.dart';
import 'package:news_paper_app/domain/usecases/news/get_top_headlines_use_case.dart';
import 'package:news_paper_app/presentation/cubits/favorite/favorite_cubit.dart';
import 'package:news_paper_app/presentation/cubits/news/news_cubit.dart';
import 'package:news_paper_app/presentation/cubits/search/search_cubit.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  final newsLocalDataSource = NewsLocalDataSource();

  await newsLocalDataSource.init();

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
    () => GetEverythingUseCase(sl<BaseNewspapersRepository>()),
  );
  sl.registerLazySingleton<FavoriteLocalDataSource>(
    () => FavoriteLocalDataSource(),
  );

  sl.registerLazySingleton<BaseFavoriteRepository>(
    () => FavoriteRepositoryImpl(sl<FavoriteLocalDataSource>()),
  );

  sl.registerLazySingleton<GetFavoritesUseCase>(
    () => GetFavoritesUseCase(sl<BaseFavoriteRepository>()),
  );

  sl.registerLazySingleton<AddFavoriteUseCase>(
    () => AddFavoriteUseCase(sl<BaseFavoriteRepository>()),
  );

  sl.registerLazySingleton<RemoveFavoriteUseCase>(
    () => RemoveFavoriteUseCase(sl<BaseFavoriteRepository>()),
  );

  sl.registerFactory<NewsCubit>(() => NewsCubit(sl<GetTopHeadlinesUseCase>()));
  sl.registerFactory<SearchCubit>(
    () => SearchCubit(sl<GetEverythingUseCase>()),
  );

  sl.registerFactory<FavoriteCubit>(
    () => FavoriteCubit(
      getFavoritesUseCase: sl<GetFavoritesUseCase>(),
      addFavoriteUseCase: sl<AddFavoriteUseCase>(),
      removeFavoriteUseCase: sl<RemoveFavoriteUseCase>(),
    ),
  );
}
