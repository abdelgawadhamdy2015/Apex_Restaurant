import 'package:apex_restaurant/featchers/orders/data/datasource/orders_remote_data_source.dart';
import 'package:apex_restaurant/featchers/orders/data/model/order_model.dart';
import 'package:apex_restaurant/featchers/orders/domain/repo/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;

  OrdersRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<OrderModel>> getPreviousOrders(OrderFilterModel? filter) =>
      remoteDataSource.getPreviousOrders(filter);

  @override
  Future<List<OrderModel>> getHeldOrders() => remoteDataSource.getHeldOrders();

  @override
  Future<void> restoreHeldOrder(String orderId) =>
      remoteDataSource.restoreHeldOrder(orderId);

  @override
  Future<void> deleteHeldOrder(String orderId) =>
      remoteDataSource.deleteHeldOrder(orderId);
}
