import '../enums/cart_enum.dart';
import 'invoice_request.dart';
import 'pos_client_model.dart';
import 'waiter_model.dart';
import '../../../pos/data/models/delivery_company.dart';
import '../../../pos/domain/entities/menu_item.dart';
import '../../../tables/domain/entities/table_entity.dart';

class RestoredCartData {
  final int? invoiceID;
  final String? invoiceCode;
  final int? orderNumber;
  final List<OrderItem> items;
  final int? voucherId;
  final DateTime? invoiceDate;
  final CartOrderType orderType;
  final PosClientModel? client;
  final WaiterModel? waiter;
  final WaiterModel? deliveryMan;
  final DeliveryCompanyModel? deliveryCompany;
  final TableEntity? table;
  final RestaurantPosDiscountRequest? restaurantPosDiscountRequest;

  const RestoredCartData({
    required this.items,
    required this.orderType,
    this.client,
    this.waiter,
    this.deliveryMan,
    this.deliveryCompany,
    this.table,
    this.restaurantPosDiscountRequest,
    this.invoiceID,
    this.invoiceCode,
    this.orderNumber,
    this.voucherId,
    this.invoiceDate,
  });
}
