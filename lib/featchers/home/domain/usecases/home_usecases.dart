import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:apex_restaurant/featchers/home/domain/repo/home_repo.dart';

class GetEmployeeBranchesUseCase {
  final HomeRepository _repository;
  GetEmployeeBranchesUseCase(this._repository);
  Future<List<EmployeeBranch>> call() => _repository.getEmployeeBranches();
}
