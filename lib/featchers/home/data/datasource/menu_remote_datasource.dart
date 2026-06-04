import 'package:apex_restaurant/core/service/api_service.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:apex_restaurant/featchers/home/data/models/user_data_model.dart';

abstract class HomeDatasource {
  Future<List<EmployeeBranch>> getEmployeeBranches();
  Future<BaseResponse<UserDataModel>> getUserData({required int id});
}

class HomeDatasourceImpl implements HomeDatasource {
  final ApiService _apiService;
  HomeDatasourceImpl(this._apiService);

  @override
  Future<List<EmployeeBranch>> getEmployeeBranches() async {
    return (await _apiService.getEmployeeBranches()).data!;
  }

  @override
  Future<BaseResponse<UserDataModel>> getUserData({required int id}) async {
    return (await _apiService.getUserData(id));
  }
}
