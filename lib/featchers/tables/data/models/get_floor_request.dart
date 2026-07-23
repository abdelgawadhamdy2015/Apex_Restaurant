import 'package:apex_restaurant/core/shared/entity/base_request.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'get_floor_request.g.dart';

@JsonSerializable()
class GetFloorsRequest extends BaseRequest {
  final String? id;
  final int? branchId;

  const GetFloorsRequest({
    super.pageNumber,
    super.pageSize,
    this.id,
    super.name,
    this.branchId,
  });
  @override
  Map<String, dynamic> toJson() => _$GetFloorsRequestToJson(this);

  factory GetFloorsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetFloorsRequestFromJson(json);
  @override
  List<Object?> get props => [pageNumber, pageSize, id, name, branchId];
}
