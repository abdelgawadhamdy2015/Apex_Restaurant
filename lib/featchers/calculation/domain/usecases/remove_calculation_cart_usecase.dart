import '../repositories/calculation_repository.dart';

class RemoveCalculationCartUseCase {
  final CalculationRepository repository;

  RemoveCalculationCartUseCase(this.repository);

  Future<void> call(String cartId) {
    return repository.removeCart(cartId);
  }
}
