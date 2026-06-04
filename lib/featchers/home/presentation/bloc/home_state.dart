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

class HomeState extends Equatable {
  final HomeStatus status;
  final EmployeeBranch? selectedEmployeeBranch;
  final String? errorMessage;
  final UserDataModel? userDataModel;
  final List<EmployeeBranch> branches;

  const HomeState({
    this.status = HomeStatus.initial,
    this.selectedEmployeeBranch,
    this.errorMessage,
    this.branches = const [],
    this.userDataModel,
  });

  factory HomeState.initial() => HomeState(status: HomeStatus.initial);

  HomeState copyWith({
    HomeStatus? status,
    EmployeeBranch? selectedEmployeeBranch,
    String? errorMessage,
    List<EmployeeBranch>? branches,
    UserDataModel? userDataModel,
  }) {
    return HomeState(
      status: status ?? this.status,
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
}
