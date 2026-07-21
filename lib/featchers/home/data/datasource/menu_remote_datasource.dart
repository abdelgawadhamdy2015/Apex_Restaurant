import 'package:apex_restaurant/core/service/api_service.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:apex_restaurant/featchers/home/data/models/session_model.dart';
import 'package:apex_restaurant/featchers/home/data/models/user_data_model.dart';

abstract class HomeDatasource {
  Future<BaseResponse<List<EmployeeBranch>?>> getEmployeeBranches();
  Future<BaseResponse<UserDataModel?>> getUserData({required int id});
  Future<BaseResponse<SessionModel?>> openRestaurantPos();
  Future<BaseResponse<SessionModel?>> openRestaurantPosSession();
}

class HomeDatasourceImpl implements HomeDatasource {
  final ApiService _apiService;
  HomeDatasourceImpl(this._apiService);

  @override
  Future<BaseResponse<List<EmployeeBranch>?>> getEmployeeBranches() async {
    return (await _apiService.getEmployeeBranches());
  }

  @override
  Future<BaseResponse<UserDataModel?>> getUserData({required int id}) async {
    return (await _apiService.getUserData(id));
  }

  @override
  Future<BaseResponse<SessionModel?>> openRestaurantPos() async {
    return (await _apiService.openRestaurantPos());
  }

  @override
  Future<BaseResponse<SessionModel?>> openRestaurantPosSession() async {
    return (await _apiService.openRestaurantPosSession());
  }
}
