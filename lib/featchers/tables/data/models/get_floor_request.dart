import '../../../../core/shared/entity/base_request.dart';

class GetFloorsRequest extends BaseRequest {
  final String? id;
  final int? branchId;

  const GetFloorsRequest({
    super.pageNumber,
    super.pageSize,
    super.name,
    this.id,
    this.branchId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      if (id != null) 'id': id,
      if (branchId != null) 'branchId': branchId,
    };
  }

  @override
  List<Object?> get props => [...super.props, id, branchId];
}
