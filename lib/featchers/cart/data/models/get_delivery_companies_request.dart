import 'package:json_annotation/json_annotation.dart';
import 'package:apex_restaurant/core/shared/entity/base_request.dart';

part 'get_delivery_companies_request.g.dart';

@JsonSerializable(includeIfNull: false)
class GetDeliveryCompaniesRequest extends BaseRequest {
  final bool? isActive;

  const GetDeliveryCompaniesRequest({
    this.isActive,
    super.pageNumber,
    super.pageSize,
  });

  factory GetDeliveryCompaniesRequest.fromJson(Map<String, dynamic> json) =>
      _$GetDeliveryCompaniesRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetDeliveryCompaniesRequestToJson(this);
}
