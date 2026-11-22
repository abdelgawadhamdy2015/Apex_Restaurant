import 'package:apex_restaurant/featchers/calculation/data/models/calculation_requests.dart';
import 'package:apex_restaurant/featchers/calculation/data/models/calculation_result.dart';
import 'package:apex_restaurant/featchers/calculation/domain/repositories/calculation_repository.dart';

class AddCalculationVoucherUseCase {
  final CalculationRepository repository;
  AddCalculationVoucherUseCase(this.repository);
  Future<CalculationResult> call(AddVoucherRequest r) =>
      repository.addVoucher(r);
}

class RemoveCalculationVoucherUseCase {
  final CalculationRepository repository;
  RemoveCalculationVoucherUseCase(this.repository);
  Future<CalculationResult> call(String cartId) =>
      repository.removeVoucher(cartId);
}
