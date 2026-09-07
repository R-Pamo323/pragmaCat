import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../errors/app_exception.dart';

class DioClient {
  late final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      sendTimeout: ApiConstants.sendTimeout,
      headers: {'x-api-key': ApiConstants.apiKey},
    ),
  )..interceptors.add(LogInterceptor(requestBody: false, responseBody: false));

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response<dynamic> response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on Exception {
      throw const UnknownException();
    }
  }
}

AppException _mapDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const TimeoutException();
    case DioExceptionType.connectionError:
      return const NoInternetException();
    case DioExceptionType.badResponse:
      final int? statusCode = error.response?.statusCode;
      if (statusCode != null && statusCode >= 500) {
        return const ServerException();
      }
      return ServerException(
        'Server returned an error (${statusCode ?? 'unknown'}).',
      );
    case DioExceptionType.badCertificate:
      return const ServerException();
    case DioExceptionType.cancel:
      return const UnknownException();
    case DioExceptionType.unknown:
      return const NoInternetException();
  }
}
