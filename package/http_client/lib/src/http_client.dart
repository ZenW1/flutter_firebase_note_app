import 'dart:convert';

import 'package:dio/dio.dart' hide ProgressCallback;
import 'package:http_client/src/interceptors/logger_interceptor.dart';

import 'exceptions/request_cancelled_exception.dart';
import 'exceptions/request_failed_exception.dart';
import 'exceptions/request_forbidden_exception.dart';
import 'exceptions/request_method_not_allowed_exception.dart';
import 'exceptions/request_not_found_exception.dart';
import 'exceptions/request_timeout_exception.dart';
import 'exceptions/request_unauthorized_exception.dart';

typedef ProgressCallback = void Function(int count, int total);

abstract class HttpClient {
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Object? body,
  });

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
  });

  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Object? body,
  });

  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<void> downloadFile(
    String path, {
    required String savePath,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required ProgressCallback onReceiveProgress,
  });
}

class DioHttpClient implements HttpClient {
  DioHttpClient({
    required Dio dio,
    required String baseUrl,
    List<Interceptor>? interceptors,
  })  : _dio = dio,
        _baseUrl = baseUrl,
        _interceptors = interceptors {
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.interceptors.add(LoggingInterceptor());
    if (_interceptors != null) {
      _dio.interceptors.addAll(_interceptors!);
    }
  }

  final Dio _dio;
  final String _baseUrl;
  // add for add more interceptor
  final List<Interceptor>? _interceptors;

  @override
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );
      return response.data!;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic body,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        queryParameters: queryParameters,
        data: body,
        options: Options(headers: headers),
      );

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        return jsonDecode(response.data as String) as Map<String, dynamic>;
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic body,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        data: body,
        options: Options(
          headers: headers,
        ),
      );
      return response.data!;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );
      return response.data!;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic body,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        data: body,
        options: Options(
          headers: headers,
        ),
      );
      return response.data!;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  // download file
  @override
  Future<void> downloadFile(
    String urlPath, {
    required String savePath,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required ProgressCallback onReceiveProgress,
  }) async {
    try {
      await _dio.download(
        urlPath,
        savePath,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  // _handleError method
  Exception _handleError(DioError e) {
    if (e.type == DioErrorType.connectionTimeout) {
      return RequestTimeoutException('Request Timeout');
    } else if (e.type == DioErrorType.cancel) {
      return RequestCancelledException('Request Cancelled');
    } else if (e.type == DioErrorType.receiveTimeout) {
      return RequestTimeoutException('Receive Timeout');
    } else if (e.type == DioErrorType.unknown) {
      final data = e.response?.data;
      switch (e.response!.statusCode) {
        case 400:
          return RequestFailedException(
            data['message'] as String? ?? 'Request Failed',
          );
        case 401:
          return RequestUnauthorizedException(
            data['message'] as String? ?? 'Request Unauthorized',
          );
        case 403:
          return RequestForbiddenException(
            data['message'] as String? ?? 'Request Forbidden',
          );
        case 404:
          return RequestNotFoundException(
            data['message'] as String? ?? 'Request Not Found',
          );
        case 405:
          return RequestMethodNotAllowedException(
            data['message'] as String? ?? 'Request Method Not Allowed',
          );
        default:
          return RequestFailedException(
            data['message'] as String? ?? 'Request Failed',
          );
      }
    } else {
      final data = e.response?.data;
      switch (e.response!.statusCode) {
        case 400:
          return BadRequestException(
            data['data']['message'] as String? ?? 'Request Failed',
          );
        case 401:
          return RequestUnauthorizedException(
            data['message'] as String? ?? 'Request Unauthorized',
          );
        case 403:
          return RequestForbiddenException(
            data['message'] as String? ?? 'Request Forbidden',
          );
        case 404:
          return RequestNotFoundException(
            data['message'] as String? ?? 'Request Not Found',
          );
        case 405:
          return RequestMethodNotAllowedException(
            data['message'] as String? ?? 'Request Method Not Allowed',
          );
        case 422:
          // return UnprocessableEntityException();
          final errors = data['data'] as Map<String, dynamic>;
          // loop through errors key
          final errorMessages = errors.keys.map((key) {
            final error = errors[key] as List<dynamic>;
            return error.join(', ');
          }).toList();
          return UnprocessableEntityException(errorMessages);
        default:
          return RequestFailedException(
            data['message'] as String? ?? 'Request Failed',
          );
      }
    }
  }
}
