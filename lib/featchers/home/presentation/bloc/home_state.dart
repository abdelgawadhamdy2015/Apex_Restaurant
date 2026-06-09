import 'package:apex_restaurant/core/shared/contracts/errorable_state.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:apex_restaurant/featchers/home/data/models/user_data_model.dart';
import 'package:equatable/equatable.dart';

enum HomeStatus {
  initial,
  loading,
  userDataLoading,
  userDataLoaded,
  loaded,
  error,
  submitting,
  submitted,
}

class HomeState extends Equatable implements ErrorableState {
  final HomeStatus status;
  @override
  final BaseResponse? apiResponse;
  final EmployeeBranch? selectedEmployeeBranch;
  final String? errorMessage;
  final UserDataModel? userDataModel;
  final List<EmployeeBranch> branches;

  const HomeState({
    this.status = HomeStatus.initial,
    this.apiResponse,
    this.selectedEmployeeBranch,
    this.errorMessage,
    this.branches = const [],
    this.userDataModel,
  });

  factory HomeState.initial() => HomeState(status: HomeStatus.initial);

  HomeState copyWith({
    HomeStatus? status,
    BaseResponse? apiResponse,
    EmployeeBranch? selectedEmployeeBranch,
    String? errorMessage,
    List<EmployeeBranch>? branches,
    UserDataModel? userDataModel,
  }) {
    return HomeState(
      status: status ?? this.status,
      apiResponse: apiResponse ?? this.apiResponse,
      selectedEmployeeBranch:
          selectedEmployeeBranch ?? this.selectedEmployeeBranch,
      errorMessage: errorMessage ?? this.errorMessage,
      branches: branches ?? this.branches,
      userDataModel: userDataModel ?? this.userDataModel,
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedEmployeeBranch,
    errorMessage,
    branches,
    userDataModel,
  ];

  @override
  bool get hasError => status == HomeStatus.error;
}
