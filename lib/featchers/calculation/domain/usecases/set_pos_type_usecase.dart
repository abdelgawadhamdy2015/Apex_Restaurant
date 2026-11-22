import 'package:apex_restaurant/featchers/calculation/data/models/calculation_requests.dart';
import 'package:apex_restaurant/featchers/calculation/data/models/calculation_result.dart';
import 'package:apex_restaurant/featchers/calculation/domain/repositories/calculation_repository.dart';

class SetCalculationPosTypeUseCase {
  final CalculationRepository repository;
  SetCalculationPosTypeUseCase(this.repository);
  Future<CalculationResult> call(SetPosTypeRequest r) =>
      repository.setPosType(r);
}
