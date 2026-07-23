import 'package:apex_restaurant/core/service/api_service.dart';
import 'package:apex_restaurant/featchers/orders/data/model/order_model.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_success_model.dart';

abstract class OrdersRemoteDataSource {
  Future<List<OrderModel>> getPreviousOrders(OrderFilterModel? filter);
  Future<List<OrderModel>> getHeldOrders();
  Future<void> restoreHeldOrder(String orderId);
  Future<void> deleteHeldOrder(String orderId);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final ApiService apiService;
  OrdersRemoteDataSourceImpl(this.apiService);
  @override
  Future<List<OrderModel>> getPreviousOrders(OrderFilterModel? filter) async {
    // API Call simulation
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      OrderModel(
        id: '1',
        invoiceNumber: 'INV-2023',
        customerName: 'أحمد محمود',
        dateTime: DateTime(2026, 6, 23, 14, 30),
        totalAmount: 120.00,
        itemsCount: 3,
      ),
      OrderModel(
        id: '2',
        invoiceNumber: 'INV-2022',
        customerName: 'محمد محمود',
        dateTime: DateTime(2026, 6, 23, 13, 15),
        totalAmount: 85.50,
        itemsCount: 2,
      ),
      OrderModel(
        id: '3',
        invoiceNumber: 'INV-2021',
        customerName: 'محمود محمود',
        dateTime: DateTime(2026, 6, 23, 12, 00),
        totalAmount: 45.00,
        itemsCount: 1,
      ),
    ];
  }

  @override
  Future<List<OrderModel>> getHeldOrders() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      OrderModel(
        id: '1024',
        orderQueueNumber: '#1024',
        invoiceNumber: 'INV-2039',
        dateTime: DateTime(2026, 6, 23, 11, 45),
        totalAmount: 132.00,
        itemsCount: 3,
        isHeld: true,
        items: [
          OrderItemModel(name: 'برجر لحم كلاسيك', quantity: 1, price: 45.00),
          OrderItemModel(name: 'بطاطس مقلية (وسط)', quantity: 2, price: 30.00),
          OrderItemModel(name: 'مشروب غازي', quantity: 3, price: 57.00),
        ],
      ),
      OrderModel(
        id: '1020',
        orderQueueNumber: '#1020',
        invoiceNumber: 'INV-2030',
        dateTime: DateTime(2026, 6, 23, 10, 15),
        totalAmount: 25.00,
        itemsCount: 1,
        isHeld: true,
        items: [OrderItemModel(name: 'وجبة اطفال', quantity: 1, price: 25.00)],
      ),
      OrderModel(
        id: '1008',
        orderQueueNumber: '#1008',
        invoiceNumber: 'INV-2012',
        dateTime: DateTime(2026, 6, 23, 9, 30),
        totalAmount: 240.50,
        itemsCount: 5,
        isHeld: true,
      ),
    ];
  }

  @override
  Future<void> restoreHeldOrder(String orderId) async {}

  @override
  Future<void> deleteHeldOrder(String orderId) async {}
}
