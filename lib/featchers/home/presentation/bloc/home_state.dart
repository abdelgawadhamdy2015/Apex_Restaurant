import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, loaded, error, submitting, submitted }

class HomeState extends Equatable {
  final HomeStatus status;
  final EmployeeBranch? selectedEmployeeBranch;
  final String? errorMessage;
  final List<EmployeeBranch> branches;

  const HomeState({
    this.status = HomeStatus.initial,
    this.selectedEmployeeBranch,
    this.errorMessage,
    this.branches = const [],
  });

  factory HomeState.initial() => HomeState(status: HomeStatus.initial);

  HomeState copyWith({
    HomeStatus? status,
    EmployeeBranch? selectedEmployeeBranch,
    String? errorMessage,
    List<EmployeeBranch>? branches,
  }) {
    return HomeState(
      status: status ?? this.status,
      selectedEmployeeBranch:
          selectedEmployeeBranch ?? this.selectedEmployeeBranch,
      errorMessage: errorMessage ?? this.errorMessage,
      branches: branches ?? this.branches,
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedEmployeeBranch,
    errorMessage,
    branches,
  ];
}
