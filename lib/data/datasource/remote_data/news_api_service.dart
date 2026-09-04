import 'package:dio/dio.dart';
import 'package:news_paper_app/core/errors/exceptions.dart';
import 'package:news_paper_app/core/network/dio_client.dart';
import 'package:news_paper_app/core/utils/api_constants.dart';
import 'package:news_paper_app/core/utils/date_utils.dart';

class NewsApiService {
  final Dio _dio;

  NewsApiService(DioClient dioClient) : _dio = dioClient.dio;
  Future<Response> getTopHeadlines({
    String? country,
    String? category,
    String? source,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.topHeadLines,
        queryParameters: {
          'country': country,
          'category': category,
          'sources': source,
          'page': page,
          'pageSize': pageSize,
        },
      );
      print(response.requestOptions.queryParameters);

      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        throw const NetworkException('check your internet connection.');
      }

      final statusCode = e.response?.statusCode;
      if (statusCode == 401) {
        throw const ServerException('Invalid API key.');
      }
      if (statusCode == 429) {
        throw const ServerException(
          'Too many requests. Please try again later.',
        );
      }
      if (statusCode != null && statusCode >= 500) {
        throw const ServerException('News server is currently unavailable.');
      }
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        throw ServerException(
          data['message']?.toString() ??
              'Something went wrong while fetching news.',
        );
      }
      throw const ServerException('Something went wrong while fetching news.');
    }
  }

  Future<Response> getEverything({
    required String query,
    String? sources,
    String? language,
    DateTime? from,
    DateTime? to,
    String? sortBy,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.everyThing,
        queryParameters: {
          'q': query,
          if (from != null) 'from': DateUtilsApp.formatDate(from),

          if (to != null) 'to': DateUtilsApp.formatDate(to),

          if (sources != null) 'sources': sources,
          if (language != null) 'language': language,
          if (sortBy != null) 'sortBy': sortBy,
          'page': page,
          'pageSize': pageSize,
        },
      );
      print(response.requestOptions.queryParameters);
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        throw const NetworkException('check your internet connection.');
      }

      final statusCode = e.response?.statusCode;
      if (statusCode == 401) {
        throw const ServerException('Invalid API key.');
      }
      if (statusCode == 429) {
        throw const ServerException(
          'Too many requests. Please try again later.',
        );
      }
      if (statusCode != null && statusCode >= 500) {
        throw const ServerException('News server is currently unavailable.');
      }
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        throw ServerException(
          data['message']?.toString() ??
              'Something went wrong while fetching news.',
        );
      }
      throw const ServerException('Something went wrong while fetching news.');
    }
  }
}
