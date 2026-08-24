import 'package:apex_restaurant/featchers/more_actions/data/datasource/more_action_datasource.dart';
import 'package:apex_restaurant/featchers/more_actions/data/repo/more_action_repo_imp.dart';
import 'package:apex_restaurant/featchers/more_actions/domain/repo/more_actions_repo.dart';
import 'package:apex_restaurant/featchers/more_actions/domain/usescase/more_actions_usescase.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/bloc/more_actions_bloc.dart';

import '../service/api_service.dart';
import '../service/dio_factory.dart';
import '../settings/settings_cubit.dart';
import '../../featchers/cart/data/datasource/cart_remote_datasource.dart';
import '../../featchers/cart/data/repo/cart_repo_imp.dart';
import '../../featchers/cart/domain/repo/cart_repo.dart';
import '../../featchers/cart/domain/usescase/cart_usescase.dart';
import '../../featchers/cart/presentation/bloc/cart_bloc.dart';
import '../../featchers/home/data/datasource/menu_remote_datasource.dart';
import '../../featchers/home/data/repo_imp/home_repo_imp.dart';
import '../../featchers/home/domain/repo/home_repo.dart';
import '../../featchers/home/domain/usecases/home_usecases.dart';
import '../../featchers/home/presentation/bloc/home_bloc.dart';
import '../../featchers/auth/data/datasource/auth_datasource.dart';
import '../../featchers/auth/data/repo_imp/login_repo.dart';
import '../../featchers/auth/domain/repo/auth_repo.dart';
import '../../featchers/auth/domain/usecases/auth_usecase.dart';
import '../../featchers/auth/presentation/bloc/auth_bloc.dart';
import '../../featchers/orders/data/datasource/orders_remote_data_source.dart';
import '../../featchers/orders/data/repo/order_repository_imp.dart';
import '../../featchers/orders/domain/repo/orders_repository.dart';
import '../../featchers/orders/domain/usescase/orders_usescase.dart';
import '../../featchers/orders/presentation/bloc/orders_bloc.dart';
import '../../featchers/payment/data/datasource/payment_remote_data_source.dart';
import '../../featchers/payment/data/repo/payment_repository_impl.dart';
import '../../featchers/payment/domain/repo/payment_repository.dart';
import '../../featchers/payment/domain/usecase/process_payment_usecase.dart';
import '../../featchers/payment/presentation/bloc/payment_bloc.dart';
import '../../featchers/pos/data/datasources/pos_remote_datasource.dart';
import '../../featchers/pos/data/repositories/pos_repository_impl.dart';
import '../../featchers/pos/domain/repositories/pos_repository.dart';
import '../../featchers/pos/domain/usecases/pos_usecases.dart';
import '../../featchers/pos/presentation/bloc/pos_bloc.dart';
import '../../featchers/tables/data/datasource/tables_remote_data_source.dart';
import '../../featchers/tables/data/repo/tables_repository_impl.dart';
import '../../featchers/tables/domain/repo/tables_repository.dart';
import '../../featchers/tables/domain/usescase/tables_usecase.dart';
import '../../featchers/tables/presentation/bloc/tables_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;
Future<void> setupGetIt() async {
  /// ─────────────────────────────────────────────────────────
  /// Core
  /// ─────────────────────────────────────────────────────────

  final dio = await DioFactory.getDio();

  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  // settings
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);
  getIt.registerLazySingleton<SettingsCubit>(
    () => SettingsCubit(getIt<SharedPreferences>()),
  );

  /// ─────────────────────────────────────────────────────────
  /// Data Sources
  /// ─────────────────────────────────────────────────────────

  // AUTH
  getIt.registerLazySingleton<AuthDatasource>(
    () => AuthDatasourceImp(getIt<ApiService>()),
  );

  //HOME
  getIt.registerLazySingleton<HomeDatasource>(
    () => HomeDatasourceImpl(getIt<ApiService>()),
  );
  //POS
  getIt.registerLazySingleton<PosRemoteDataSource>(
    () => PosRemoteDataSourceImpl(getIt<ApiService>()),
  );

  //Cart
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(getIt<ApiService>()),
  );

  //Payment
  getIt.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(getIt<ApiService>()),
  );

  //Orders
  getIt.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(getIt<ApiService>()),
  );

  // Tables
  getIt.registerLazySingleton<TablesRemoteDataSource>(
    () => TablesRemoteDataSourceImpl(getIt<ApiService>()),
  );

  // More Actions
  getIt.registerLazySingleton<MoreActionDatasource>(
    () => MoreActionsRemoteDataSourceImpl(getIt<ApiService>()),
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

  // Cart
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(getIt<CartRemoteDataSource>()),
  );

  // Payment
  getIt.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(getIt<PaymentRemoteDataSource>()),
  );

  // Orders
  getIt.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(getIt<OrdersRemoteDataSource>()),
  );

  // Tables
  getIt.registerLazySingleton<TablesRepository>(
    () => TablesRepositoryImpl(getIt<TablesRemoteDataSource>()),
  );
  // More Actions
  getIt.registerLazySingleton<MoreActionsRepo>(
    () => MoreActionRepoImp(getIt<MoreActionDatasource>()),
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

  getIt.registerLazySingleton(
    () => GetUserDataUseCase(getIt<HomeRepository>()),
  );

  getIt.registerLazySingleton(
    () => OpenRestaurantPosUseCase(getIt<HomeRepository>()),
  );

  getIt.registerLazySingleton(
    () => OpenRestaurantPosSessionUseCase(getIt<HomeRepository>()),
  );

  //POS
  getIt.registerLazySingleton(
    () => GetMenuCategoriesUseCase(getIt<PosRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetMenuItemsByCategoryUseCase(getIt<PosRepository>()),
  );

  getIt.registerLazySingleton(
    () => GetFoodAdditivesUseCase(getIt<PosRepository>()),
  );

  getIt.registerLazySingleton(() => GetSettingsUseCase(getIt<PosRepository>()));
  getIt.registerLazySingleton(
    () => CloseRestaurantPosSessionUseCase(getIt<PosRepository>()),
  );

  getIt.registerLazySingleton(
    () => CurrentRestaurantPosSessionUseCase(getIt<PosRepository>()),
  );

  // cart
  getIt.registerLazySingleton(() => GetWaitersUseCase(getIt<CartRepository>()));
  getIt.registerLazySingleton(
    () => GetDeliveryAgentsUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton(
    () => ApplyDiscountUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetAllDeliveryCompanyUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton(
    () => SavePendingRestaurantPosInvoiceUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton(
    () => SaveBookingTableRestaurantPosInvoiceUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetAllPosClientsUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton(
    () => AddPosClientUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton(
    () => UpdatePosClientUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetDynamicInvoiceDiscountUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton(
    () => CheckVoucherUseCase(getIt<CartRepository>()),
  );

  // Payment
  getIt.registerLazySingleton(
    () => SavePaymentRestaurantPosInvoiceUseCase(getIt<PaymentRepository>()),
  );

  // Orders
  getIt.registerLazySingleton(
    () => GetPindingInvoicesUseCase(getIt<OrdersRepository>()),
  );

  getIt.registerLazySingleton(
    () => GetPreviousOrdersUseCase(getIt<OrdersRepository>()),
  );
  getIt.registerLazySingleton(
    () => RestoreHeldOrderUseCase(getIt<OrdersRepository>()),
  );
  getIt.registerLazySingleton(
    () => DeleteHeldOrderUseCase(getIt<OrdersRepository>()),
  );

  // Tables
  getIt.registerLazySingleton(
    () => GetFloorsUseCase(getIt<TablesRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetTablesUseCase(getIt<TablesRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetReservationsUseCase(getIt<TablesRepository>()),
  );
  getIt.registerLazySingleton(
    () => CreateReservationUseCase(getIt<TablesRepository>()),
  );
  getIt.registerLazySingleton(
    () => CancelReservationUseCase(getIt<TablesRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetPindingTableInvoiceUseCase(getIt<TablesRepository>()),
  );

  // Tables
  getIt.registerLazySingleton(
    () => GetAllPOSInvoicesUseCase(getIt<MoreActionsRepo>()),
  );
  getIt.registerLazySingleton(
    () => AddPOSResturnInvoiceUseCase(getIt<MoreActionsRepo>()),
  );

  getIt.registerLazySingleton(
    () => AddPOSTotalReturnInvoiceUseCase(getIt<MoreActionsRepo>()),
  );

  /// ─────────────────────────────────────────────────────────
  /// BLoCs
  /// ─────────────────────────────────────────────────────────

  // AUTH
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(loginUsecase: getIt<LoginUsecase>()),
  );

  //HOME
  getIt.registerFactory(
    () => HomeBloc(
      getUseDataUseCase: getIt<GetUserDataUseCase>(),
      getEmployeeBranches: getIt<GetEmployeeBranchesUseCase>(),
      openRestaurantPosSessionUseCase: getIt<OpenRestaurantPosSessionUseCase>(),
      openRestaurantPosUseCase: getIt<OpenRestaurantPosUseCase>(),
    ),
  );

  //POS
  getIt.registerLazySingleton<PosBloc>(
    () => PosBloc(
      getSettingsUseCase: getIt<GetSettingsUseCase>(),
      getMenuCategories: getIt<GetMenuCategoriesUseCase>(),
      getfoodAdditivesUseCase: getIt<GetFoodAdditivesUseCase>(),
      itemsByCategoryUseCase: getIt<GetMenuItemsByCategoryUseCase>(),
      closeRestaurantPosSessionUseCase:
          getIt<CloseRestaurantPosSessionUseCase>(),
      currentRestaurantPosSessionUseCase:
          getIt<CurrentRestaurantPosSessionUseCase>(),
    ),
  );

  // Cart
  getIt.registerFactory<CartBloc>(
    () => CartBloc(
      getAllDeliveryCompanyUseCase: getIt<GetAllDeliveryCompanyUseCase>(),
      getDeliveryAgentsUseCase: getIt<GetDeliveryAgentsUseCase>(),
      getWaitersUseCase: getIt<GetWaitersUseCase>(),
      applyDiscountUseCase: getIt<ApplyDiscountUseCase>(),
      savePendingRestaurantPosInvoiceUseCase:
          getIt<SavePendingRestaurantPosInvoiceUseCase>(),
      saveBookingTableRestaurantPosInvoiceUseCase:
          getIt<SaveBookingTableRestaurantPosInvoiceUseCase>(),

      getAllPersonsUseCase: getIt<GetAllPosClientsUseCase>(),
      addPosClientUseCase: getIt<AddPosClientUseCase>(),
      updatePosClientUseCase: getIt<UpdatePosClientUseCase>(),
      getDynamicInvoiceDiscountUseCase:
          getIt<GetDynamicInvoiceDiscountUseCase>(),
      checkVoucherUseCase: getIt<CheckVoucherUseCase>(),
    ),
  );

  // Payment
  getIt.registerFactory<PaymentBloc>(
    () => PaymentBloc(
      processPaymentUseCase: getIt<SavePaymentRestaurantPosInvoiceUseCase>(),
    ),
  );

  // Orders
  getIt.registerFactory(
    () => OrdersBloc(
      getPreviousOrdersUseCase: getIt<GetPreviousOrdersUseCase>(),
      getPindingInvoicesUseCase: getIt<GetPindingInvoicesUseCase>(),

      restoreHeldOrderUseCase: getIt<RestoreHeldOrderUseCase>(),
      deleteHeldOrderUseCase: getIt<DeleteHeldOrderUseCase>(),
    ),
  );

  // Tables
  getIt.registerFactory(
    () => TablesBloc(
      restoreHeldOrderUseCase: getIt<RestoreHeldOrderUseCase>(),
      getPindingTableInvoiceUseCase: getIt<GetPindingTableInvoiceUseCase>(),
      getReservationsUseCase: getIt<GetReservationsUseCase>(),
      createReservationUseCase: getIt<CreateReservationUseCase>(),
      cancelReservationUseCase: getIt<CancelReservationUseCase>(),
      getFloorsUseCase: getIt<GetFloorsUseCase>(),
      getTablesUseCase: getIt<GetTablesUseCase>(),
    ),
  );

  // More Actions
  getIt.registerFactory(
    () => MoreActionsBloc(
      getAllPOSInvoicesUseCase: getIt<GetAllPOSInvoicesUseCase>(),
      addPOSResturnInvoiceUseCase: getIt<AddPOSResturnInvoiceUseCase>(),
      addPOSTotalReturnInvoiceUseCase: getIt<AddPOSTotalReturnInvoiceUseCase>(),
    ),
  );
}
