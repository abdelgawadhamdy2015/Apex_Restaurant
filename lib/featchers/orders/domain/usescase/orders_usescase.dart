import 'package:apex_restaurant/featchers/orders/data/model/order_model.dart';
import 'package:apex_restaurant/featchers/orders/domain/repo/orders_repository.dart';

class GetPreviousOrdersUseCase {
  final OrdersRepository repository;
  GetPreviousOrdersUseCase(this.repository);
  Future<List<OrderModel>> call(OrderFilterModel? filter) =>
      repository.getPreviousOrders(filter);
}

class GetHeldOrdersUseCase {
  final OrdersRepository repository;
  GetHeldOrdersUseCase(this.repository);
  Future<List<OrderModel>> call() => repository.getHeldOrders();
}

class RestoreHeldOrderUseCase {
  final OrdersRepository repository;
  RestoreHeldOrderUseCase(this.repository);
  Future<void> call(String orderId) => repository.restoreHeldOrder(orderId);
}

class DeleteHeldOrderUseCase {
  final OrdersRepository repository;
  DeleteHeldOrderUseCase(this.repository);
  Future<void> call(String orderId) => repository.deleteHeldOrder(orderId);
}
