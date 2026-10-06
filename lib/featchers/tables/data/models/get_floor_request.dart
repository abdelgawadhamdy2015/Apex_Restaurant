import '../../../../core/shared/entity/base_request.dart';

class GetFloorsRequest extends BaseRequest {
  final String? id;

  const GetFloorsRequest({
    super.pageNumber,
    super.pageSize,
    super.name,
    this.id,
  });

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), if (id != null) 'id': id};
  }

  @override
  List<Object?> get props => [...super.props, id];
}
