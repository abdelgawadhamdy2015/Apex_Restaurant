import 'package:apex_restaurant/featchers/calculation/data/models/calculation_requests.dart';
import 'package:apex_restaurant/featchers/calculation/data/models/calculation_result.dart';
import 'package:apex_restaurant/featchers/calculation/domain/repositories/calculation_repository.dart';

class SetDiscountOnTotalUseCase {
  final CalculationRepository repository;
  SetDiscountOnTotalUseCase(this.repository);
  Future<CalculationResult> call(SetDiscountOnTotalRequest r) =>
      repository.setDiscountOnTotal(r);
}
