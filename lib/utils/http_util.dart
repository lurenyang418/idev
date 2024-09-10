import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "en";
const String TOKEN = "Bearer token";
const String BASE_URL = "https://wpapi.ducafecat.tech";

class HttpUtil {
  static final HttpUtil _singleton = HttpUtil._internal();
  factory HttpUtil() => _singleton;

  late Dio _dio;

  HttpUtil._internal() {
    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: TOKEN,
      DEFAULT_LANGUAGE: DEFAULT_LANGUAGE,
    };
    // 初始选项
    var options = BaseOptions(
      baseUrl: BASE_URL,
      headers: headers,
      connectTimeout: const Duration(seconds: 5), // 5秒
      receiveTimeout: const Duration(seconds: 3), // 3秒
      responseType: ResponseType.json,
    );

    _dio = Dio(options);

    // 拦截器 - 日志打印
    if (!kReleaseMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }
  }

  /// get 请求
  Future<Response> get(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();
    Response response = await _dio.get(
      url,
      queryParameters: params,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// post 请求
  Future<Response> post(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var requestOptions = options ?? Options();
    Response response = await _dio.post(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// put 请求
  Future<Response> put(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var requestOptions = options ?? Options();
    Response response = await _dio.put(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// delete 请求
  Future<Response> delete(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var requestOptions = options ?? Options();
    Response response = await _dio.delete(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// patch 请求
  Future<Response> patch(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var requestOptions = options ?? Options();
    Response response = await _dio.patch(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }
}
