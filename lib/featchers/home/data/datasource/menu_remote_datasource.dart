import 'package:apex_restaurant/featchers/home/data/models/open_restaurant_pos_session.dart';
import 'package:apex_restaurant/featchers/home/data/models/safe_model.dart';

import '../../../../core/service/api_service.dart';
import '../../../../core/shared/model/base_response.dart';
import '../models/employee_branch.dart';
import '../models/session_model.dart';
import '../models/user_data_model.dart';

abstract class HomeDatasource {
  Future<BaseResponse<List<EmployeeBranch>?>> getEmployeeBranches();
  Future<BaseResponse<UserDataModel?>> getUserData({required int id});
  Future<BaseResponse<SessionModel?>> openRestaurantPos();
  Future<BaseResponse<SessionModel?>> openRestaurantPosSession(
    OpenSessionRequest request,
  );
  Future<BaseResponse<List<SafeModel>?>> getAllTreasuryByUserDropDown();
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
  Future<BaseResponse<SessionModel?>> openRestaurantPosSession(
    OpenSessionRequest request,
  ) async {
    return (await _apiService.openRestaurantPosSession(request));
  }

  @override
  Future<BaseResponse<List<SafeModel>?>> getAllTreasuryByUserDropDown() async {
    return (await _apiService.getAllTreasuryByUserDropDown());
  }
}
