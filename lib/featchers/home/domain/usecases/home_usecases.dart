import 'package:apex_restaurant/featchers/home/data/models/open_restaurant_pos_session.dart';
import 'package:apex_restaurant/featchers/home/data/models/safe_model.dart';

import '../../../../core/service/api_result.dart';
import '../../../../core/shared/model/base_response.dart';
import '../../data/models/employee_branch.dart';
import '../../data/models/session_model.dart';
import '../../data/models/user_data_model.dart';
import '../repo/home_repo.dart';

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
  Future<ApiResult<BaseResponse<SessionModel?>>> call(
    OpenSessionRequest request,
  ) => _repository.openRestaurantPosSession(request);
}

class OpenRestaurantPosUseCase {
  final HomeRepository _repository;
  OpenRestaurantPosUseCase(this._repository);
  Future<ApiResult<BaseResponse<SessionModel?>>> call() =>
      _repository.openRestaurantPos();
}

class GetAllTreasuryByUserDropDownUseCase {
  final HomeRepository _repository;
  GetAllTreasuryByUserDropDownUseCase(this._repository);
  Future<ApiResult<BaseResponse<List<SafeModel>?>>> call() =>
      _repository.getAllTreasuryByUserDropDown();
}
