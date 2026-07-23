import 'package:apex_restaurant/core/shared/entity/base_request.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'get_table_request.g.dart';

@JsonSerializable()
class GetTablesRequest extends BaseRequest {
  final String? id;

  final String? floorID;
  final bool? forPOS;

  const GetTablesRequest({
    super.pageNumber,
    super.pageSize,
    this.id,
    super.name,
    this.floorID,
    this.forPOS,
  });
  factory GetTablesRequest.fromJson(Map<String, dynamic> json) =>
      _$GetTablesRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetTablesRequestToJson(this);
}
