import 'package:dio/dio.dart';

class ApiConstants {
  static const String baseUsrl = localUrl;

  static const String localUrl = "http://192.168.1.253:1313/api/";
  static const String login = "Login";

  static DioExceptionType dioExceptionType = DioExceptionType.unknown;

  static int? userId;

  static int? empId;
}

class ApiErrors {
  static const String methodNotAllowed = "method Not Allowed Error";

  static const String badRequestError = "bad request Error";
  static const String noContent = "no Content";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorized Error";
  static const String notFoundError = "not Found Error";
  static const String conflictError = "conflict Error";
  static const String internalServerError = "internal Server Error";
  static const String unknownError = "unknown Error";
  static const String timeoutError = "timeout Error";
  static const String defaultError = "default Error";
  static const String cacheError = "cache Error";
  static const String noInternetError = "no Internet Connection";
  static const String loadingMessage = "loading";
  static const String retryAgainMessage = "retry again";
}
