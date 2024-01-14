import 'package:e_commerce/features/auth/data/repo/repository.dart';
import 'package:e_commerce/features/auth/data/source/local/local_source.dart';
import 'package:e_commerce/features/auth/data/source/remote/remote_source.dart';
import 'package:e_commerce/features/auth/domain/repo/repository.dart';
import 'package:e_commerce/features/auth/domain/usecase/login.dart';
import 'package:e_commerce/features/auth/domain/usecase/login_with_facebook.dart';
import 'package:e_commerce/features/auth/domain/usecase/login_with_gmail.dart';
import 'package:e_commerce/features/auth/domain/usecase/sign_out.dart';
import 'package:e_commerce/features/auth/domain/usecase/sign_up.dart';
import 'package:e_commerce/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Auth
  //?usecases
  sl.registerLazySingleton<LoginWithGmailUseCase>(
      () => LoginWithGmailUseCase(authDomainRepo: sl()));
  sl.registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(authDomainRepo: sl()));
  sl.registerLazySingleton<SignUpUseCase>(
      () => SignUpUseCase(authDomainRepo: sl()));
  sl.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(authDomainRepo: sl()));
  sl.registerLazySingleton<LoginWithFacebookUseCase>(
      () => LoginWithFacebookUseCase(authDomainRepo: sl()));
  //?repositories
  sl.registerLazySingleton<AuthDomainRepo>(() => AuthDataRepo(
      authRemoteSourceImplement: sl(), authLocalSourceImplement: sl()));

  //?remote source
  sl.registerLazySingleton<AuthRemoteSourceImplement>(
      () => AuthRemoteSourceImplement());

  //? local Source
  sl.registerLazySingleton<AuthLocalSourceImplement>(
      () => AuthLocalSourceImplement(sharedPreferences: sl()));
  //?cubits
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl(), sl(), sl(), sl(),sl(),sl()));

  //? Core
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => sharedPreferences);
}
