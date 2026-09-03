import 'package:apex_restaurant/featchers/home/data/models/safe_model.dart';

import '../../../../core/service/api_error_handler.dart';
import '../../../../core/service/api_result.dart';
import '../../../../core/shared/model/base_response.dart';
import '../datasource/menu_remote_datasource.dart';
import '../models/employee_branch.dart';
import '../models/session_model.dart';
import '../models/user_data_model.dart';
import '../../domain/repo/home_repo.dart';

class HomeRepoImpl implements HomeRepository {
  final HomeDatasource _remoteDataSource;

  HomeRepoImpl(this._remoteDataSource);

  @override
  Future<ApiResult<BaseResponse<List<EmployeeBranch>?>>>
  getEmployeeBranches() async {
    try {
      final response = await _remoteDataSource.getEmployeeBranches();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<BaseResponse<UserDataModel?>>> getUserData({
    required int id,
  }) async {
    try {
      final response = await _remoteDataSource.getUserData(id: id);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<BaseResponse<SessionModel?>>> openRestaurantPos() async {
    try {
      final response = await _remoteDataSource.openRestaurantPos();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<BaseResponse<SessionModel?>>>
  openRestaurantPosSession() async {
    try {
      final response = await _remoteDataSource.openRestaurantPosSession();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<BaseResponse<List<SafeModel>?>>>
  getAllTreasuryByUserDropDown() async {
    try {
      final response = await _remoteDataSource.getAllTreasuryByUserDropDown();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
