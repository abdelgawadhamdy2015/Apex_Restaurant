import 'package:apex_restaurant/featchers/home/data/datasource/menu_remote_datasource.dart';
import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:apex_restaurant/featchers/home/domain/repo/home_repo.dart';

class HomeRepoImpl implements HomeRepository {
  final HomeDatasource _remoteDataSource;

  HomeRepoImpl(this._remoteDataSource);

  @override
  Future<List<EmployeeBranch>> getEmployeeBranches() async {
    final branches = await _remoteDataSource.getEmployeeBranches();
    return branches;
  }
}
