import '../../../../core/service/api_result.dart';
import '../../../../core/shared/model/base_response.dart';
import '../../data/models/employee_branch.dart';
import '../../data/models/session_model.dart';
import '../../data/models/user_data_model.dart';

abstract class HomeRepository {
  Future<ApiResult<BaseResponse<List<EmployeeBranch>?>>> getEmployeeBranches();
  Future<ApiResult<BaseResponse<UserDataModel?>>> getUserData({
    required int id,
  });
  Future<ApiResult<BaseResponse<SessionModel?>>> openRestaurantPos();
  Future<ApiResult<BaseResponse<SessionModel?>>> openRestaurantPosSession();
}
