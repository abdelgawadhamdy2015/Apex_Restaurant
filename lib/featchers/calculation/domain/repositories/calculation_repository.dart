import '../../data/models/calculation_requests.dart';
import '../../data/models/calculation_result.dart';

abstract class CalculationRepository {
  Future<String?> openNewCart(OpenNewCartRequest request);

  Future<CalculationResult?> addItem(AddCalculationItemRequest request);
  Future<CalculationResult> editItem(EditCalculationItemRequest request);

  Future<CalculationResult> clearAllItems(String cartId);

  Future<void> removeCart(String cartId);
}
