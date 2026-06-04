// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) =>
    EmployeeModel(
      id: (json['id'] as num?)?.toInt(),
      isServiceProvider: json['isServiceProvider'] as bool?,
      code: (json['code'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      arabicName: json['arabicName'] as String?,
      latinName: json['latinName'] as String?,
      jobId: (json['jobId'] as num?)?.toInt(),
      image: json['image'] as String?,
      imagePath: json['imagePath'] as String?,
      notes: json['notes'] as String?,
      gLBranchId: (json['gLBranchId'] as num?)?.toInt(),
      financialAccountId: (json['financialAccountId'] as num?)?.toInt(),
      canDelete: json['canDelete'] as bool?,
      userId: (json['userId'] as num?)?.toInt(),
      uTime: json['uTime'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      salesPriceId: (json['salesPriceId'] as num?)?.toInt(),
      activateMaobileApp: json['activateMaobileApp'] as bool?,
    );

Map<String, dynamic> _$EmployeeModelToJson(EmployeeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isServiceProvider': instance.isServiceProvider,
      'code': instance.code,
      'status': instance.status,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'jobId': instance.jobId,
      'image': instance.image,
      'imagePath': instance.imagePath,
      'notes': instance.notes,
      'gLBranchId': instance.gLBranchId,
      'financialAccountId': instance.financialAccountId,
      'canDelete': instance.canDelete,
      'userId': instance.userId,
      'uTime': instance.uTime,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'salesPriceId': instance.salesPriceId,
      'activateMaobileApp': instance.activateMaobileApp,
    };
