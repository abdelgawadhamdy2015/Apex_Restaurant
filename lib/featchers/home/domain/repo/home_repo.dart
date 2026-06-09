import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:apex_restaurant/featchers/home/data/models/user_data_model.dart';

abstract class HomeRepository {
  Future<ApiResult<BaseResponse<List<EmployeeBranch>?>>> getEmployeeBranches();
  Future<ApiResult<BaseResponse<UserDataModel?>>> getUserData({
    required int id,
  });
}
