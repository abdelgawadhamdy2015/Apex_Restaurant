import '../../data/models/calculation_requests.dart';
import '../../data/models/calculation_result.dart';
import '../repositories/calculation_repository.dart';

class EditListOfItemUsecase {
  final CalculationRepository repository;

  EditListOfItemUsecase(this.repository);

  Future<CalculationResult> call(EditListOfItemsRequest request) {
    return repository.editListOfItems(request);
  }
}
