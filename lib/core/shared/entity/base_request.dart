import 'package:equatable/equatable.dart';

class BaseRequest extends Equatable {
  final String? name;
  final int? pageNumber;
  final int? pageSize;

  const BaseRequest({this.name, this.pageNumber, this.pageSize});

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (pageNumber != null) 'pageNumber': pageNumber,
    if (pageSize != null) 'pageSize': pageSize,
  };

  @override
  List<Object?> get props => [name, pageNumber, pageSize];
}
