import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:server_api_client_dart/server_api_client_dart.dart';

const String _serverEndpoint = "http://10.0.0.247:10000";

/// Uses singleton throughout application to access Server API.
extension ServerClient on ServerApiClientDart {
  static final ServerApiClientDart instance = ServerApiClientDart(
    basePathOverride: _serverEndpoint,
    dio: Dio()
      ..options = BaseOptions(
          baseUrl: _serverEndpoint,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 30),
          headers: {
            // "User-Agent": FkUserAgent.userAgent ?? "App/1.0.0",
            "User-Agent": "App/1.0.0",
            "Accept-Language": "en",
          }
      )
      ..interceptors.add(ServerClientErrorInterceptor()),
  );

  /// Sets the current access token on Cloak API client.
  /// [token] the token to be used
  void setAccessToken(final String token) {
    dio.options.headers["Authorization"] = "Bearer $token";
  }

  /// Removes the current access token from Cloak API client.
  void clearAccessToken() {
    dio.options.headers.remove("Authorization");
  }
}

/// Normalized error response structure from Server API.
final class ServerClientError extends DioException implements Equatable {
  final int statusCode;
  final DateTime timestamp;
  final String? appCode;

  ServerClientError(final DioException parent, {
    required String message,
    this.appCode,
    required this.statusCode,
    required this.timestamp,
  }): super(
    requestOptions: parent.requestOptions,
    message: message,
    response: parent.response,
    type: parent.type,
    error: parent.error,
    stackTrace: parent.stackTrace,
  );

  @override
  bool? get stringify => null;

  @override
  List<Object?> get props => [appCode, statusCode, message, timestamp];

  @override
  String toString() => "ServerClientError [${type.name}]: $message";

  @override
  String get message => super.message!;
}

/// Converts all [DioException] into [ServerClientError].
/// Knows how to parse normalized error response from Server API server.
final class ServerClientErrorInterceptor extends InterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final String message;
    final int statusCode;
    final DateTime timestamp;
    final String? appCode;

    final Map<String, dynamic>? data = err.response?.data;
    if (data != null) {
      message = data["message"];
      statusCode = data["status_code"];
      timestamp = DateTime.parse(data["timestamp"]);
      appCode = data["app_code"];
    } else {
      message = "Unknown error occurred, please try again!";
      statusCode = 0;
      timestamp = DateTime.now();
      appCode = null;
    }

    handler.reject(ServerClientError(
      err,
      message: message,
      appCode: appCode,
      statusCode: statusCode,
      timestamp: timestamp,
    ));
  }
}
