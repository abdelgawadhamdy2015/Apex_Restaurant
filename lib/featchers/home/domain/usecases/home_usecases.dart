import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:apex_restaurant/featchers/home/data/models/session_model.dart';
import 'package:apex_restaurant/featchers/home/data/models/user_data_model.dart';
import 'package:apex_restaurant/featchers/home/domain/repo/home_repo.dart';

class GetEmployeeBranchesUseCase {
  final HomeRepository _repository;
  GetEmployeeBranchesUseCase(this._repository);
  Future<ApiResult<BaseResponse<List<EmployeeBranch>?>>> call() =>
      _repository.getEmployeeBranches();
}

class GetUserDataUseCase {
  final HomeRepository _repository;
  GetUserDataUseCase(this._repository);
  Future<ApiResult<BaseResponse<UserDataModel?>>> call({required int id}) =>
      _repository.getUserData(id: id);
}

class OpenRestaurantPosSessionUseCase {
  final HomeRepository _repository;
  OpenRestaurantPosSessionUseCase(this._repository);
  Future<ApiResult<BaseResponse<SessionModel?>>> call() =>
      _repository.openRestaurantPosSession();
}

class OpenRestaurantPosUseCase {
  final HomeRepository _repository;
  OpenRestaurantPosUseCase(this._repository);
  Future<ApiResult<BaseResponse<SessionModel?>>> call() =>
      _repository.openRestaurantPos();
}
