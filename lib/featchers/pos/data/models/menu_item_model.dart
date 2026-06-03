import 'package:json_annotation/json_annotation.dart';

import 'category_model.dart';
import 'item_unit_model.dart';

part 'menu_item_model.g.dart';

@JsonSerializable()
class MenuItemModel {
  final int? id;
  final String? itemCode;
  final int? typeId;

  final bool? usedInSales;
  final bool? canReturnBackToStore;

  final int? depositeUnit;
  final int? withdrawUnit;
  final int? reportUnit;

  final double? vat;
  final bool? applyVAT;

  final String? model;
  final String? description;

  final String? arabicName;
  final String? latinName;

  final int? groupId;
  final int? status;

  final String? image;
  final String? imageName;
  final String? imagePath;

  final CategoryModel? category;

  final List<ItemUnitModel>? units;

  const MenuItemModel({
    this.id,
    this.itemCode,
    this.typeId,
    this.usedInSales,
    this.canReturnBackToStore,
    this.depositeUnit,
    this.withdrawUnit,
    this.reportUnit,
    this.vat,
    this.applyVAT,
    this.model,
    this.description,
    this.arabicName,
    this.latinName,
    this.groupId,
    this.status,
    this.image,
    this.imageName,
    this.imagePath,
    this.category,
    this.units,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) =>
      _$MenuItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemModelToJson(this);
}
