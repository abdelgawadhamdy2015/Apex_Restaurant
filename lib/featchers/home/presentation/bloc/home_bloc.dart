import '../../../../core/helpers/restaurant_constants.dart';
import '../../../../core/service/api_result.dart';
import '../../../../core/shared/model/base_response.dart';
import '../../data/models/session_model.dart';
import '../../data/models/user_data_model.dart';
import '../../domain/usecases/home_usecases.dart';
import 'home_event.dart';
import 'home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetEmployeeBranchesUseCase getEmployeeBranches;
  final GetUserDataUseCase getUseDataUseCase;
  final OpenRestaurantPosSessionUseCase openRestaurantPosSessionUseCase;
  final OpenRestaurantPosUseCase openRestaurantPosUseCase;

  HomeBloc({
    required this.getEmployeeBranches,
    required this.getUseDataUseCase,
    required this.openRestaurantPosSessionUseCase,
    required this.openRestaurantPosUseCase,
  }) : super(HomeState.initial()) {
    on<LoadUserDataEvent>(_onLoadUserData);
    on<LoadBranchesEvent>(_onLoadEmployeeBranches);
    on<SelectBranchEvent>(_onSelectBranch);
    on<OpenRestaurantPosEvent>(_onOpenRestaurantPos);
    on<OpenRestaurantPosSessionEvent>(_onOpenRestaurantPosSession);
  }

  Future<void> _onLoadUserData(
    LoadUserDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.userDataLoading, clearError: true));
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
            emit(
              state.copyWith(
                status: HomeStatus.error,
                errorMessage: data.errorMessageAr,
                apiResponse: data,
              ),
            );
          }
        },
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'فشل في تحميل بيانات المستخدم، يرجى المحاولة لاحقاً',
        ),
      );
    }
  }

  Future<void> _onLoadEmployeeBranches(
    LoadBranchesEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.branchesLoading, clearError: true));
    try {
      final response = await getEmployeeBranches();
      response.when(
        success: (data) {
          if (data.result == 1) {
            emit(
              state.copyWith(
                status: HomeStatus.branchesLoaded,
                branches: data.data ?? [],
              ),
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
        failure: (e) {
          emit(
            state.copyWith(
              status: HomeStatus.error,
              errorMessage: e.apiErrorModel.errorMessageAr,
            ),
          );
        },
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'فشل في تحميل الفروع المتاحة، يرجى إعادة المحاولة',
        ),
      );
    }
  }

  Future<void> _onOpenRestaurantPos(
    OpenRestaurantPosEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(status: HomeStatus.openSessionLoading, clearError: true),
    );
    try {
      final response = await openRestaurantPosUseCase();
      response.when(
        failure: (e) => emit(
          state.copyWith(
            status: HomeStatus.error,
            errorMessage: e.apiErrorModel.errorMessageAr,
          ),
        ),
        success: (BaseResponse<SessionModel?> data) {
          if (data.result == 1) {
            emit(
              state.copyWith(
                status: HomeStatus.openSessionLoaded,
                sessionModel: data.data,
              ),
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
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'حدث خطأ أثناء فتح الجلسة، يرجى المحاولة لاحقاً',
        ),
      );
    }
  }

  Future<void> _onOpenRestaurantPosSession(
    OpenRestaurantPosSessionEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(status: HomeStatus.openSessionLoading, clearError: true),
    );
    try {
      final response = await openRestaurantPosSessionUseCase();
      response.when(
        failure: (e) => emit(
          state.copyWith(
            status: HomeStatus.error,
            errorMessage: e.apiErrorModel.errorMessageAr,
          ),
        ),
        success: (BaseResponse<SessionModel?> data) {
          if (data.result == 1) {
            emit(
              state.copyWith(
                status: HomeStatus.openSessionLoaded,
                sessionModel: data.data,
              ),
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
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'حدث خطأ أثناء فتح الجلسة، يرجى المحاولة لاحقاً',
        ),
      );
    }
  }

  void _onSelectBranch(SelectBranchEvent event, Emitter<HomeState> emit) {
    RestaurantConstants.currentBranch = event.branch;
    emit(state.copyWith(selectedEmployeeBranch: event.branch));
  }
}
