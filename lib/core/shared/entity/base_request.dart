import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'base_request.g.dart';

@JsonSerializable()
class BaseRequest extends Equatable {
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

  factory BaseRequest.fromJson(Map<String, dynamic> json) =>
      _$BaseRequestFromJson(json);
  Map<String, dynamic> toJson() => _$BaseRequestToJson(this);

  @override
  List<Object?> get props => [name, pageNumber, pageSize];
}
