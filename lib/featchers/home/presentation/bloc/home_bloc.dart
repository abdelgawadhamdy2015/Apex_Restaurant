import 'package:apex_restaurant/featchers/home/domain/usescases/home_usecases.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_event.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetEmployeeBranchesUseCase getEmployeeBranches;
  HomeBloc({required this.getEmployeeBranches}) : super(HomeState.initial()) {
    on<LoadBranchesEvent>(_onLoadEmployeeBranches);
    on<SelectBranchEvent>(_onSelectBranch);
  }

  Future<void> _onLoadEmployeeBranches(
    LoadBranchesEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final branches = await getEmployeeBranches();
      emit(state.copyWith(status: HomeStatus.loaded, branches: branches));
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'Failed to load branches. Please try again.',
        ),
      );
    }
  }

  void _onSelectBranch(SelectBranchEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedEmployeeBranch: event.branch));
  }
}
