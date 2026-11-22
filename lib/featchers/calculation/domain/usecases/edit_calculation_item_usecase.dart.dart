import '../../data/models/calculation_requests.dart';
import '../../data/models/calculation_result.dart';
import '../repositories/calculation_repository.dart';

class EditCalculationItemUseCase {
  final CalculationRepository repository;

  EditCalculationItemUseCase(this.repository);

  Future<CalculationResult> call(EditCalculationItemRequest request) {
    return repository.editItem(request);
  }
}
