// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:dio/dio.dart';

import 'api_constants.dart';
import 'api_error_model.dart';

enum DataSource {
  METHOD_NOT_ALLOWED,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  CONFLICT,
  // API_LOGIC_ERROR,
  DEFAULT,
}

class ResponseCode {
  static const int SUCCESS = 200; // success with data
  static const int NO_CONTENT = 201; // success with no data (no content)
  static const int BAD_REQUEST = 400; // failure, API rejected request
  static const int UNAUTORISED = 401; // failure, user is not authorised
  static const int FORBIDDEN = 403; //  failure, API rejected request
  static const int CONFLICT = 409;
  static const int INTERNAL_SERVER_ERROR = 500; // failure, crash in server side
  static const int NOT_FOUND = 404; // failure, not found
  static const int API_LOGIC_ERROR = 422; // API , lOGIC ERROR
  static const int METHOD_NOT_ALLOWED = 405; // failure, crash in server side

  // local status code
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
}

class ResponseMessage {
  static const String METHOD_NOT_ALLOWED = ApiErrors.methodNotAllowed;

  static const String CONFLICT = ApiErrors.conflictError;
  static const String NO_CONTENT =
      ApiErrors.noContent; // success with no data (no content)
  static const String BAD_REQUEST =
      ApiErrors.badRequestError; // failure, API rejected request
  static const String UNAUTORISED =
      ApiErrors.unauthorizedError; // failure, user is not authorised
  static const String FORBIDDEN =
      ApiErrors.forbiddenError; //  failure, API rejected request
  static const String INTERNAL_SERVER_ERROR =
      ApiErrors.internalServerError; // failure, crash in server side
  static const String NOT_FOUND =
      ApiErrors.notFoundError; // failure, crash in server side

  // local status code
  static String CONNECT_TIMEOUT = ApiErrors.timeoutError;
  static String CANCEL = ApiErrors.defaultError;
  static String RECIEVE_TIMEOUT = ApiErrors.timeoutError;
  static String SEND_TIMEOUT = ApiErrors.timeoutError;
  static String CACHE_ERROR = ApiErrors.cacheError;
  static String NO_INTERNET_CONNECTION = ApiErrors.noInternetError;
  static String DEFAULT = ApiErrors.defaultError;
}

extension DataSourceExtension on DataSource {
  ApiErrorModel getFailure() {
    switch (this) {
      case DataSource.NO_CONTENT:
        return ApiErrorModel(
          code: ResponseCode.NO_CONTENT,
          errorMessageEn: ResponseMessage.NO_CONTENT,
          errorMessageAr: ResponseMessage.NO_CONTENT,
        );
      case DataSource.BAD_REQUEST:
        return ApiErrorModel(
          code: ResponseCode.BAD_REQUEST,
          errorMessageEn: ResponseMessage.BAD_REQUEST,
          errorMessageAr: ResponseMessage.BAD_REQUEST,
        );
      case DataSource.FORBIDDEN:
        return ApiErrorModel(
          errorMessageAr: ResponseMessage.FORBIDDEN,
          code: ResponseCode.FORBIDDEN,
          errorMessageEn: ResponseMessage.FORBIDDEN,
        );
      case DataSource.UNAUTORISED:
        return ApiErrorModel(
          errorMessageEn: ResponseMessage.UNAUTORISED,
          code: ResponseCode.UNAUTORISED,
          errorMessageAr: ResponseMessage.UNAUTORISED,
        );
      case DataSource.NOT_FOUND:
        return ApiErrorModel(
          errorMessageEn: ResponseMessage.NOT_FOUND,
          code: ResponseCode.NOT_FOUND,
          errorMessageAr: ResponseMessage.NOT_FOUND,
        );
      case DataSource.INTERNAL_SERVER_ERROR:
        return ApiErrorModel(
          code: ResponseCode.INTERNAL_SERVER_ERROR,
          errorMessageEn: ResponseMessage.INTERNAL_SERVER_ERROR,
          errorMessageAr: ResponseMessage.INTERNAL_SERVER_ERROR,
        );
      case DataSource.CONNECT_TIMEOUT:
        return ApiErrorModel(
          code: ResponseCode.CONNECT_TIMEOUT,
          errorMessageEn: ResponseMessage.CONNECT_TIMEOUT,
          errorMessageAr: ResponseMessage.CONNECT_TIMEOUT,
        );
      case DataSource.CANCEL:
        return ApiErrorModel(
          errorMessageEn: ResponseMessage.CANCEL,
          code: ResponseCode.CANCEL,
          errorMessageAr: ResponseMessage.CANCEL,
        );
      case DataSource.RECIEVE_TIMEOUT:
        return ApiErrorModel(
          errorMessageEn: ResponseMessage.RECIEVE_TIMEOUT,
          code: ResponseCode.RECIEVE_TIMEOUT,
          errorMessageAr: ResponseMessage.RECIEVE_TIMEOUT,
        );
      case DataSource.SEND_TIMEOUT:
        return ApiErrorModel(
          errorMessageEn: ResponseMessage.SEND_TIMEOUT,
          code: ResponseCode.SEND_TIMEOUT,
          errorMessageAr: ResponseMessage.SEND_TIMEOUT,
        );
      case DataSource.CACHE_ERROR:
        return ApiErrorModel(
          errorMessageAr: ResponseMessage.NO_CONTENT,
          code: ResponseCode.CACHE_ERROR,
          errorMessageEn: ResponseMessage.CACHE_ERROR,
        );
      case DataSource.CONFLICT:
        return ApiErrorModel(
          errorMessageEn: ResponseMessage.CONFLICT,
          errorMessageAr: ResponseMessage.CONFLICT,
          code: ResponseCode.CONFLICT,
        );
      case DataSource.NO_INTERNET_CONNECTION:
        return ApiErrorModel(
          code: ResponseCode.NO_INTERNET_CONNECTION,
          errorMessageAr: ResponseMessage.NO_INTERNET_CONNECTION,
          errorMessageEn: ResponseMessage.NO_INTERNET_CONNECTION,
        );
      case DataSource.METHOD_NOT_ALLOWED:
        return ApiErrorModel(
          errorMessageEn: ResponseMessage.METHOD_NOT_ALLOWED,
          code: ResponseCode.METHOD_NOT_ALLOWED,
          errorMessageAr: ResponseMessage.METHOD_NOT_ALLOWED,
        );
      case DataSource.DEFAULT:
        return ApiErrorModel(
          errorMessageEn: ResponseMessage.DEFAULT,
          code: ResponseCode.DEFAULT,
          errorMessageAr: ResponseMessage.DEFAULT,
        );
    }
  }
}

class ErrorHandler implements Exception {
  late ApiErrorModel apiErrorModel;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      // dio error so its an error from response of the API or from dio itself
      apiErrorModel = _handleError(error);
    } else {
      // default error
      apiErrorModel = DataSource.DEFAULT.getFailure();
    }
  }

  /// Returns readable message in EN or AR with safe fallback
  String message({String? locale}) {
    if (locale == 'en') {
      return apiErrorModel.errorMessageEn ??
          apiErrorModel.errorMessageAr ??
          'Unexpected error';
    } else {
      return apiErrorModel.errorMessageAr ??
          apiErrorModel.errorMessageEn ??
          'حدث خطأ غير متوقع';
    }
  }

  /// Prevents "Instance of 'ErrorHandler'"
  @override
  String toString() {
    return 'ErrorHandler(code: ${apiErrorModel.code}, '
        'en: ${apiErrorModel.errorMessageEn}, '
        'ar: ${apiErrorModel.errorMessageAr})';
  }
}

ApiErrorModel _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      ApiConstants.dioExceptionType = DioExceptionType.connectionTimeout;
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioExceptionType.sendTimeout:
      return DataSource.SEND_TIMEOUT.getFailure();
    case DioExceptionType.receiveTimeout:
      return DataSource.RECIEVE_TIMEOUT.getFailure();
    case DioExceptionType.badResponse:
      if (error.response != null &&
          error.response?.statusCode != null &&
          error.response?.statusMessage != null) {
        if (error.response!.statusCode == ResponseCode.UNAUTORISED ||
            error.response!.statusCode == ResponseCode.CONFLICT) {
          ApiConstants.dioExceptionType = DioExceptionType.badResponse;
        }
        if (error.response!.statusCode == ResponseCode.INTERNAL_SERVER_ERROR) {
          ApiConstants.dioExceptionType = DioExceptionType.badResponse;

          return DataSource.INTERNAL_SERVER_ERROR.getFailure();
        }
        if (error.response!.statusCode == ResponseCode.NOT_FOUND) {
          return DataSource.NOT_FOUND.getFailure();
        }
        if (error.response!.statusCode == ResponseCode.METHOD_NOT_ALLOWED) {
          return DataSource.METHOD_NOT_ALLOWED.getFailure();
        }

        return ApiErrorModel.fromJson(error.response!.data);
      } else {
        return DataSource.DEFAULT.getFailure();
      }
    case DioExceptionType.unknown:
      if (error.response != null &&
          error.response?.statusCode != null &&
          error.response?.statusMessage != null) {
        return ApiErrorModel.fromJson(error.response!.data);
      } else {
        return DataSource.DEFAULT.getFailure();
      }
    case DioExceptionType.cancel:
      return DataSource.CANCEL.getFailure();
    case DioExceptionType.connectionError:
      return DataSource.NO_INTERNET_CONNECTION.getFailure();
    case DioExceptionType.badCertificate:
      return DataSource.DEFAULT.getFailure();
  }
}

class ApiInternalStatus {
  static const int SUCCESS = 0;
  static const int FAILURE = 1;
}
