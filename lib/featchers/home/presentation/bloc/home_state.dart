// --- HOME STATE ---
import 'package:apex_restaurant/core/shared/contracts/errorable_state.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:apex_restaurant/featchers/home/data/models/session_model.dart';
import 'package:apex_restaurant/featchers/home/data/models/user_data_model.dart';
import 'package:equatable/equatable.dart';

enum HomeStatus {
  initial,
  branchesLoading,
  branchesLoaded,
  userDataLoading,
  userDataLoaded,
  openSessionLoading,
  openSessionLoaded,
  error,
}

class HomeState extends Equatable implements ErrorableState {
  final HomeStatus status;
  @override
  final BaseResponse? apiResponse;
  final EmployeeBranch? selectedEmployeeBranch;
  final String? errorMessage;
  final UserDataModel? userDataModel;
  final List<EmployeeBranch> branches;
  final SessionModel? sessionModel;

  const HomeState({
    this.status = HomeStatus.initial,
    this.apiResponse,
    this.selectedEmployeeBranch,
    this.errorMessage,
    this.branches = const [],
    this.userDataModel,
    this.sessionModel,
  });

  factory HomeState.initial() => const HomeState(status: HomeStatus.initial);

  HomeState copyWith({
    HomeStatus? status,
    BaseResponse? apiResponse,
    EmployeeBranch? selectedEmployeeBranch,
    String? errorMessage,
    List<EmployeeBranch>? branches,
    UserDataModel? userDataModel,
    SessionModel? sessionModel,
    bool clearError = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      apiResponse: apiResponse ?? this.apiResponse,
      selectedEmployeeBranch:
          selectedEmployeeBranch ?? this.selectedEmployeeBranch,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      branches: branches ?? this.branches,
      userDataModel: userDataModel ?? this.userDataModel,
      sessionModel: sessionModel ?? this.sessionModel,
    );
  }

  @override
  List<Object?> get props => [
    status,
    apiResponse,
    selectedEmployeeBranch,
    errorMessage,
    branches,
    userDataModel,
    sessionModel,
  ];

  @override
  bool get hasError => status == HomeStatus.error;
}
