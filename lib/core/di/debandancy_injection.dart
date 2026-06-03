import 'package:apex_restaurant/core/service/api_service.dart';
import 'package:apex_restaurant/core/service/dio_factory.dart';
import 'package:apex_restaurant/featchers/home/data/datasource/menu_remote_datasource.dart';
import 'package:apex_restaurant/featchers/home/data/repo_imp/home_repo_imp.dart';
import 'package:apex_restaurant/featchers/home/domain/repo/home_repo.dart';
import 'package:apex_restaurant/featchers/home/domain/usecases/home_usecases.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/login/data/datasource/auth_datasource.dart';
import 'package:apex_restaurant/featchers/login/data/repo_imp/login_repo.dart';
import 'package:apex_restaurant/featchers/login/domain/repo/auth_repo.dart';
import 'package:apex_restaurant/featchers/login/domain/usecases/auth_usecase.dart';
import 'package:apex_restaurant/featchers/login/presentation/bloc/auth_bloc.dart';
import 'package:apex_restaurant/featchers/pos/data/datasources/pos_remote_datasource.dart';
import 'package:apex_restaurant/featchers/pos/data/repositories/pos_repository_impl.dart';
import 'package:apex_restaurant/featchers/pos/domain/repositories/pos_repository.dart';
import 'package:apex_restaurant/featchers/pos/domain/usecases/pos_usecases.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  /// ─────────────────────────────────────────────────────────
  /// Core
  /// ─────────────────────────────────────────────────────────

  final dio = DioFactory.getDio();

  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  /// ─────────────────────────────────────────────────────────
  /// Data Sources
  /// ─────────────────────────────────────────────────────────

  // AUTH
  getIt.registerLazySingleton<AuthDatasource>(
    () => AuthDatasourceImp(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<HomeDatasource>(
    () => HomeDatasourceImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<PosRemoteDataSource>(
    () => PosRemoteDataSourceImpl(getIt<ApiService>()),
  );

  /// ─────────────────────────────────────────────────────────
  /// Repositories
  /// ─────────────────────────────────────────────────────────

  // AUTH
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImp(getIt<AuthDatasource>()),
  );

  //HOME
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepoImpl(getIt<HomeDatasource>()),
  );

  //POS
  getIt.registerLazySingleton<PosRepository>(
    () => PosRepositoryImpl(getIt<PosRemoteDataSource>()),
  );

  /// ─────────────────────────────────────────────────────────
  /// Use Cases
  /// ─────────────────────────────────────────────────────────

  // AUTH
  getIt.registerLazySingleton(() => LoginUsecase(getIt<AuthRepo>()));

  //HOME
  getIt.registerLazySingleton(
    () => GetEmployeeBranchesUseCase(getIt<HomeRepository>()),
  );

  //POS
  getIt.registerLazySingleton(
    () => GetMenuCategoriesUseCase(getIt<PosRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetMenuItemsByCategoryUseCase(getIt<PosRepository>()),
  );
  getIt.registerLazySingleton(
    () => SendToKitchenUseCase(getIt<PosRepository>()),
  );
  getIt.registerLazySingleton(() => SubmitOrderUseCase(getIt<PosRepository>()));
  getIt.registerLazySingleton(() => GetFloorsUseCase(getIt<PosRepository>()));
  getIt.registerLazySingleton(() => GetTablesUseCase(getIt<PosRepository>()));

  /// ─────────────────────────────────────────────────────────
  /// BLoCs
  /// ─────────────────────────────────────────────────────────

  // AUTH
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(loginUsecase: getIt<LoginUsecase>()),
  );

  //HOME
  getIt.registerFactory(
    () => HomeBloc(getEmployeeBranches: getIt<GetEmployeeBranchesUseCase>()),
  );

  //POS
  getIt.registerFactory(
    () => PosBloc(
      getMenuCategories: getIt<GetMenuCategoriesUseCase>(),
      sendToKitchen: getIt<SendToKitchenUseCase>(),
      submitOrder: getIt<SubmitOrderUseCase>(),
      getFloors: getIt<GetFloorsUseCase>(),
      getTables: getIt<GetTablesUseCase>(),
      itemsByCategoryUseCase: getIt<GetMenuItemsByCategoryUseCase>(),
    ),
  );
}
