import 'package:apex_restaurant/core/service/api_service.dart';
import 'package:apex_restaurant/core/service/dio_factory.dart';
import 'package:apex_restaurant/featchers/login/data/repo_imp/login_repo.dart';
import 'package:apex_restaurant/featchers/login/domain/repo/auth_repo.dart';
import 'package:apex_restaurant/featchers/login/presentation/providers/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  /// ─────────────────────────────────────────────────────────
  /// Core
  /// ─────────────────────────────────────────────────────────

  final dio = DioFactory.getDio();

  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  /// ─────────────────────────────────────────────────────────
  /// Repository
  /// ─────────────────────────────────────────────────────────

  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImp(getIt<ApiService>()));

  /// ─────────────────────────────────────────────────────────
  /// Bloc
  /// ─────────────────────────────────────────────────────────

  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepo>()));
}
