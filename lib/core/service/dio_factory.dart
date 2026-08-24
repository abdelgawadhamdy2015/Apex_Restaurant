import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../helpers/restaurant_constants.dart';
import '../helpers/shared_prf_helper.dart';

class DioFactory {
  DioFactory._();

  static final Dio dio = _initDio();

  static Dio _initDio() {
    final dioInstance = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Accept': 'application/json'},
        validateStatus: (status) =>
            status != null && status >= 200 && status < 500,
      ),
    );

    // 1. Auto-convert models to JSON Maps before logger runs
    dioInstance.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.data != null) {
            options.data = _serializeData(options.data);
          }
          return handler.next(options);
        },
      ),
    );

    // 2. Add PrettyDioLogger ONLY ONCE
    dioInstance.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ),
    );

    return dioInstance;
  }

  static Future<Dio> getDio() async {
    final token = await SharedPrefHelper.getString(RestaurantConstants.myToken);

    if (token.isNotEmpty) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      dio.options.headers.remove('Authorization');
    }

    return dio;
  }

  static void setToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static void clearToken() {
    dio.options.headers.remove('Authorization');
  }

  /// Recursively converts request objects or Maps containing models to json
  static dynamic _serializeData(dynamic data) {
    if (data == null) return null;

    // 1. Handle Map
    if (data is Map) {
      return data.map((key, value) => MapEntry(key, _serializeData(value)));
    }

    // 2. Handle List
    if (data is List) {
      return data.map((e) => _serializeData(e)).toList();
    }

    // 3. Handle custom object with toJson()
    try {
      final json = (data as dynamic).toJson();
      // Recursively serialize the resulting Map/List to catch nested model lists like Additives
      return _serializeData(json);
    } catch (_) {}

    return data;
  }
}
