import '../../data/models/calculation_result.dart';
import '../repositories/calculation_repository.dart';

class ClearCalculationItemsUseCase {
  final CalculationRepository repository;

  ClearCalculationItemsUseCase(this.repository);

  Future<CalculationResult> call(String cartId) {
    return repository.clearAllItems(cartId);
  }
}
