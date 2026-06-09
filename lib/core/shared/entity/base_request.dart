class BaseRequest {
  final String? name;
  final int pageNumber;
  final int pageSize;

  const BaseRequest({this.name, this.pageNumber = 1, this.pageSize = 20});

  BaseRequest copyWith({String? name, int? pageNumber, int? pageSize}) {
    return BaseRequest(
      name: name ?? this.name,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
