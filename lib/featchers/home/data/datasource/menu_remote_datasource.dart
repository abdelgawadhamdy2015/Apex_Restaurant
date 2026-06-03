import 'package:apex_restaurant/core/service/api_service.dart';
import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';

abstract class HomeDatasource {
  Future<List<EmployeeBranch>> getEmployeeBranches();
}

class HomeDatasourceImpl implements HomeDatasource {
  final ApiService _apiService;
  HomeDatasourceImpl(this._apiService);

  @override
  Future<List<EmployeeBranch>> getEmployeeBranches() async {
    return (await _apiService.getEmployeeBranches()).data!;
  }
}
