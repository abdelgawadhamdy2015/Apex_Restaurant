import '../../../../core/shared/entity/base_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_reservations_request.g.dart';

@JsonSerializable()
class GetReservationRequest extends BaseRequest {
  final String? foodTableName;
  final String? customerName;

  @JsonKey(name: 'datefrom')
  final String? dateFrom;

  final String? dateTo;
  final int? status;

  const GetReservationRequest({
    super.pageNumber,
    super.pageSize,
    this.foodTableName,
    this.customerName,
    this.dateFrom,
    this.dateTo,
    this.status,
  });

  factory GetReservationRequest.fromJson(Map<String, dynamic> json) =>
      _$GetReservationRequestFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$GetReservationRequestToJson(this);

  @override
  List<Object?> get props => [
    pageNumber,
    pageSize,
    foodTableName,
    customerName,
    dateFrom,
    dateTo,
    status,
  ];
}
