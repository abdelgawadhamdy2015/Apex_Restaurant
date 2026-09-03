import 'package:apex_restaurant/featchers/home/data/models/safe_model.dart';

import '../../data/models/employee_branch.dart';
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserDataEvent extends HomeEvent {
  final int id;
  const LoadUserDataEvent({required this.id});

  @override
  List<Object?> get props => [id];
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

class OpenRestaurantPosEvent extends HomeEvent {
  const OpenRestaurantPosEvent();
}

class OpenRestaurantPosSessionEvent extends HomeEvent {
  final double openingBalance;
  const OpenRestaurantPosSessionEvent({required this.openingBalance});

  @override
  List<Object?> get props => [openingBalance];
}

class LoadTreasuryEvent extends HomeEvent {
  const LoadTreasuryEvent();
}

class SelectTreasuryEvent extends HomeEvent {
  final SafeModel safe;
  const SelectTreasuryEvent(this.safe);

  @override
  List<Object?> get props => [safe];
}
