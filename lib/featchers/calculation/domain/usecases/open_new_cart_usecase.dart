import '../../data/models/calculation_requests.dart';
import '../repositories/calculation_repository.dart';

class OpenNewCalculationCartUseCase {
  final CalculationRepository repository;

  OpenNewCalculationCartUseCase(this.repository);

  Future<String?> call(OpenNewCartRequest request) {
    return repository.openNewCart(request);
  }
}
