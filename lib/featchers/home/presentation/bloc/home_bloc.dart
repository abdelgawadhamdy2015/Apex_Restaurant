import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/home/data/models/user_data_model.dart';
import 'package:apex_restaurant/featchers/home/domain/usecases/home_usecases.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_event.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetEmployeeBranchesUseCase getEmployeeBranches;
  final GetUserDataUseCase getUseDataUseCase;

  HomeBloc({required this.getEmployeeBranches, required this.getUseDataUseCase})
    : super(HomeState.initial()) {
    on<LoadUserDataEvent>(_onLoadUserData);
    on<LoadBranchesEvent>(_onLoadEmployeeBranches);
    on<SelectBranchEvent>(_onSelectBranch);
  }

  Future<void> _onLoadUserData(
    LoadUserDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.userDataLoading));
    try {
      final response = await getUseDataUseCase(id: event.id);
      response.when(
        failure: (e) => emit(
          state.copyWith(
            status: HomeStatus.error,
            errorMessage: e.apiErrorModel.errorMessageAr,
          ),
        ),
        success: (BaseResponse<UserDataModel?> data) {
          if (data.result == 1) {
            emit(
              state.copyWith(
                status: HomeStatus.userDataLoaded,
                userDataModel: data.data,
              ),
            );
          } else {
            emit(state.copyWith(status: HomeStatus.error, apiResponse: data));
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'Failed to load branches. Please try again.',
        ),
      );
    }
  }

  Future<void> _onLoadEmployeeBranches(
    LoadBranchesEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final response = await getEmployeeBranches();
      response.when(
        success: (data) {
          if (data.result == 1) {
            emit(
              state.copyWith(status: HomeStatus.loaded, branches: data.data),
            );
          } else {
            emit(
              state.copyWith(
                status: HomeStatus.error,
                errorMessage: data.errorMessageAr,
                apiResponse: data,
              ),
            );
          }
        },
        failure: (e) {},
      );
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
    RestaurantConstants.currentBranch = event.branch;
    emit(state.copyWith(selectedEmployeeBranch: event.branch));
  }
}
