import 'package:apex_restaurant/featchers/cart/data/models/check_voucher_response.dart';
import 'package:apex_restaurant/featchers/orders/data/model/restored_invoice_model.dart'
    show RestoredInvoicePayment;

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
  final String? voucherId;
  final CheckVoucherResponse? voucherData;
  final DateTime? invoiceDate;
  final CartOrderType orderType;
  final PosClientModel? client;
  final WaiterModel? waiter;
  final WaiterModel? deliveryMan;
  final DeliveryCompanyModel? deliveryCompany;
  final TableEntity? table;
  final RestaurantPosDiscountRequest? restaurantPosDiscountRequest;
  final bool? isReturnInvoice;
  final List<RestoredInvoicePayment> payments;
  final double? totalInvoicePrice;
  final double? paidAmount;
  final String? notes;
  final String? voucherCode;
  final double? deliveryCost;
  final double? totalVat;
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
    this.voucherData,
    this.isReturnInvoice = false,
    required this.payments,
    this.totalInvoicePrice,
    this.paidAmount,
    this.notes,
    this.voucherCode,
    this.deliveryCost,
    this.totalVat,
  });
}
