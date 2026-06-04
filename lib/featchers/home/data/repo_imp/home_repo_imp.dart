import 'package:apex_restaurant/core/service/api_error_handler.dart';
import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/home/data/datasource/menu_remote_datasource.dart';
import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:apex_restaurant/featchers/home/data/models/user_data_model.dart';
import 'package:apex_restaurant/featchers/home/domain/repo/home_repo.dart';

class HomeRepoImpl implements HomeRepository {
  final HomeDatasource _remoteDataSource;

  HomeRepoImpl(this._remoteDataSource);

  @override
  Future<List<EmployeeBranch>> getEmployeeBranches() async {
    final branches = await _remoteDataSource.getEmployeeBranches();
    return branches;
  }

  @override
  Future<ApiResult<BaseResponse<UserDataModel>>> getUserData({
    required int id,
  }) async {
    try {
      final response = await _remoteDataSource.getUserData(id: id);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
