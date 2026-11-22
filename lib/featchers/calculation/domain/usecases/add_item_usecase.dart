import '../../data/models/calculation_requests.dart';
import '../../data/models/calculation_result.dart';
import '../repositories/calculation_repository.dart';

class AddCalculationItemUseCase {
  final CalculationRepository repository;

  AddCalculationItemUseCase(this.repository);

  Future<CalculationResult?> call({
    required AddCalculationItemRequest request,
  }) {
    return repository.addItem(request);
  }
}
