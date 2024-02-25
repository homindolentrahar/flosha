import 'package:dio/dio.dart';

enum ApiMethod {
  get("GET"),
  post("POST"),
  put("PUT"),
  patch("PATCH"),
  delete("DELET");

  final String value;

  const ApiMethod(this.value);
}

class ApiClient {
  late Dio _dio;

  ApiClient._({
    String baseUrl = "",
    Map<String, dynamic>? headers,
    int timeout = 30,
    String contentType = "",
    BaseOptions? options,
  }) {
    _dio = Dio(
      options ??
          BaseOptions(
            baseUrl: baseUrl,
            headers: headers,
            contentType: contentType,
            connectTimeout: Duration(seconds: timeout),
            sendTimeout: Duration(seconds: timeout),
          ),
    );
  }

  factory ApiClient.create({
    required String baseUrl,
    String contentType = "application/json",
    Map<String, dynamic>? headers,
    int timeout = 30000,
  }) =>
      ApiClient._(
        headers: headers,
        timeout: timeout,
        baseUrl: baseUrl,
        contentType: contentType,
      );

  factory ApiClient.createWithOptions({
    required BaseOptions options,
  }) =>
      ApiClient._(options: options);

  Future<Map<String, dynamic>> requestCall({
    required String endpoint,
    required ApiMethod method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    final options = Options(
      method: method.value,
      headers: _dio.options.headers,
      contentType: _dio.options.contentType,
    )
        .compose(
          _dio.options,
          endpoint,
          data: data,
          queryParameters: query,
        )
        .copyWith(baseUrl: _dio.options.baseUrl);
    final result = await _dio.fetch<Map<String, dynamic>>(options);
    return result.data ?? {};
  }
}
