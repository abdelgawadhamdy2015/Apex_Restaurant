import 'package:apex_restaurant/core/shared/model/base_response.dart';

abstract class ErrorableState {
  /// The raw API response — null means no error has occurred yet.
  BaseResponse? get apiResponse;

  /// True when the bloc is in an error state.
  bool get hasError;
}
