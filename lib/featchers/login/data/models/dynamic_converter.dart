import 'package:apex_restaurant/featchers/login/data/models/login_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class DynamicDataConverter<T> implements JsonConverter<dynamic, Object?> {
  const DynamicDataConverter();

  @override
  dynamic fromJson(Object? json) {
    if (json is Map<String, dynamic>) {
      return LoginData.fromJson(json);
    }
    if (json is num) {
      return json.toDouble();
    }

    return json;
  }

  @override
  Object? toJson(dynamic object) {
    if (object is LoginData) {
      return object.toJson();
    }
    return object;
  }
}
