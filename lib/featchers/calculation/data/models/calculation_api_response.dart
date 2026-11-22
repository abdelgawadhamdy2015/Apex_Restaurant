class CalculationApiResponse<T> {
  final int? result;
  final T? data;
  final String? note;
  final String? errorMessageAr;
  final String? errorMessageEn;

  const CalculationApiResponse({
    this.result,
    this.data,
    this.note,
    this.errorMessageAr,
    this.errorMessageEn,
  });

  factory CalculationApiResponse.fromJson(
    Map<String, dynamic> json,
    T? Function(dynamic json) fromData,
  ) {
    return CalculationApiResponse<T>(
      result: (json['result'] as num?)?.toInt(),
      data: json['data'] == null ? null : fromData(json['data']),
      note: json['note'] as String?,
      errorMessageAr: json['errorMessageAr'] as String?,
      errorMessageEn: json['errorMessageEn'] as String?,
    );
  }

  bool get isSuccess => result == 1;
}
