import 'package:apex_restaurant/core/service/api_service.dart';
import 'package:apex_restaurant/core/service/dio_factory.dart';
import 'package:apex_restaurant/core/settings/settings_cubit.dart';
import 'package:apex_restaurant/featchers/cart/data/datasource/cart_remote_datasource.dart';
import 'package:apex_restaurant/featchers/cart/data/repo/cart_repo_imp.dart';
import 'package:apex_restaurant/featchers/cart/domain/repo/cart_repo.dart';
import 'package:apex_restaurant/featchers/cart/domain/usescase/cart_usescase.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
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
import 'package:apex_restaurant/featchers/orders/data/datasource/orders_remote_data_source.dart';
import 'package:apex_restaurant/featchers/orders/data/repo/order_repository_imp.dart';
import 'package:apex_restaurant/featchers/orders/domain/repo/orders_repository.dart';
import 'package:apex_restaurant/featchers/orders/domain/usescase/orders_usescase.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_bloc.dart';
import 'package:apex_restaurant/featchers/payment/data/datasource/payment_remote_data_source.dart';
import 'package:apex_restaurant/featchers/payment/data/repo/payment_repository_impl.dart';
import 'package:apex_restaurant/featchers/payment/domain/repo/payment_repository.dart';
import 'package:apex_restaurant/featchers/payment/domain/usecase/process_payment_usecase.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_bloc.dart';
import 'package:apex_restaurant/featchers/pos/data/datasources/pos_remote_datasource.dart';
import 'package:apex_restaurant/featchers/pos/data/repositories/pos_repository_impl.dart';
import 'package:apex_restaurant/featchers/pos/domain/repositories/pos_repository.dart';
import 'package:apex_restaurant/featchers/pos/domain/usecases/pos_usecases.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/tables/data/datasource/tables_remote_data_source.dart';
import 'package:apex_restaurant/featchers/tables/data/repo/tables_repository_impl.dart';
import 'package:apex_restaurant/featchers/tables/domain/repo/tables_repository.dart';
import 'package:apex_restaurant/featchers/tables/domain/usescase/get_reservations_usecase.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_bloc.dart';
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
    () => SendToKitchenUseCase(getIt<PosRepository>()),
  );
  getIt.registerLazySingleton(() => SubmitOrderUseCase(getIt<PosRepository>()));
  getIt.registerLazySingleton(
    () => GetFoodAdditivesUseCase(getIt<PosRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetAllDeliveryCompanyUseCase(getIt<PosRepository>()),
  );

  // cart
  getIt.registerLazySingleton(() => GetWaitersUseCase(getIt<CartRepository>()));
  getIt.registerLazySingleton(
    () => GetDeliveryAgentsUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton(
    () => ApplyDiscountUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton(() => HoldOrderUseCase(getIt<CartRepository>()));

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

  // Payment
  getIt.registerLazySingleton(
    () => SaveRestaurantPosInvoice(getIt<PaymentRepository>()),
  );

  // Orders
  getIt.registerLazySingleton(
    () => GetPreviousOrdersUseCase(getIt<OrdersRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetHeldOrdersUseCase(getIt<OrdersRepository>()),
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
  getIt.registerFactory<PosBloc>(
    () => PosBloc(
      getMenuCategories: getIt<GetMenuCategoriesUseCase>(),
      getfoodAdditivesUseCase: getIt<GetFoodAdditivesUseCase>(),
      itemsByCategoryUseCase: getIt<GetMenuItemsByCategoryUseCase>(),
    ),
  );

  // Cart
  getIt.registerFactory<CartBloc>(
    () => CartBloc(
      getDeliveryAgentsUseCase: getIt<GetDeliveryAgentsUseCase>(),
      getWaitersUseCase: getIt<GetWaitersUseCase>(),
      applyDiscountUseCase: getIt<ApplyDiscountUseCase>(),
      holdOrderUseCase: getIt<HoldOrderUseCase>(),
      getAllPersonsUseCase: getIt<GetAllPosClientsUseCase>(),
      addPosClientUseCase: getIt<AddPosClientUseCase>(),
      updatePosClientUseCase: getIt<UpdatePosClientUseCase>(),
      getDynamicInvoiceDiscountUseCase:
          getIt<GetDynamicInvoiceDiscountUseCase>(),
    ),
  );

  // Payment
  getIt.registerFactory<PaymentBloc>(
    () => PaymentBloc(processPaymentUseCase: getIt<SaveRestaurantPosInvoice>()),
  );

  // Orders
  getIt.registerFactory(
    () => OrdersBloc(
      getPreviousOrdersUseCase: getIt<GetPreviousOrdersUseCase>(),
      getHeldOrdersUseCase: getIt<GetHeldOrdersUseCase>(),
      restoreHeldOrderUseCase: getIt<RestoreHeldOrderUseCase>(),
      deleteHeldOrderUseCase: getIt<DeleteHeldOrderUseCase>(),
    ),
  );

  // Tables
  getIt.registerFactory(
    () => TablesBloc(
      getReservationsUseCase: getIt<GetReservationsUseCase>(),
      createReservationUseCase: getIt<CreateReservationUseCase>(),
      cancelReservationUseCase: getIt<CancelReservationUseCase>(),
      getFloorsUseCase: getIt<GetFloorsUseCase>(),
      getTablesUseCase: getIt<GetTablesUseCase>(),
    ),
  );
}
