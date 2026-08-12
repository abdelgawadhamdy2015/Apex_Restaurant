import 'package:apex_restaurant/featchers/cart/data/enums/cart_enum.dart';
import 'package:apex_restaurant/featchers/cart/data/models/invoice_request_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/waiter_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/table_entity.dart';

class RestoredCartData {
  final List<OrderItem> items;
  final CartOrderType orderType;
  final PosClientModel? client;
  final WaiterModel? waiter;
  final WaiterModel? deliveryMan;
  final DeliveryCompanyModel? deliveryCompany;
  final TableEntity? table;
  final SaveDiscountModel? saveDiscountModel;

  const RestoredCartData({
    required this.items,
    required this.orderType,
    this.client,
    this.waiter,
    this.deliveryMan,
    this.deliveryCompany,
    this.table,
    this.saveDiscountModel,
  });
}
