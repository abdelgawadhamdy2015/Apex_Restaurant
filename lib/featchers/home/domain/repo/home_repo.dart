import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';

abstract class HomeRepository {
  Future<List<EmployeeBranch>> getEmployeeBranches();
}
