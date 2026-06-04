import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class LoadUserDataEvent extends HomeEvent {
  final int id;
  const LoadUserDataEvent({required this.id});
}

class LoadBranchesEvent extends HomeEvent {
  const LoadBranchesEvent();
}

class SelectBranchEvent extends HomeEvent {
  final EmployeeBranch branch;
  const SelectBranchEvent(this.branch);
  @override
  List<Object?> get props => [branch];
}
