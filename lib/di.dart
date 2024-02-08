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
import 'package:e_commerce/features/home/data/repo/home_data_repo.dart';
import 'package:e_commerce/features/home/data/source/remote_source/home_remote_source.dart';
import 'package:e_commerce/features/home/domain/repo/home_domain_rep.dart';
import 'package:e_commerce/features/home/domain/usecases/get_all_products.dart';
import 'package:e_commerce/features/home/presentation/cubit/home_cubit.dart';
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
  sl.registerFactory<AuthCubit>(
      () => AuthCubit(sl(), sl(), sl(), sl(), sl(), sl()));

  //! Home
  //? remote source
  sl.registerLazySingleton<HomeRemoteSource>(
    () => HomeRemoteSourceImlp(),
  );
  //? repo
  sl.registerLazySingleton<HomeDomainRepo>(
      () => HomeDataRepo(homeRemoteSource: sl()));
  //? usecases
  sl.registerLazySingleton<GetAllProducts>(
      () => GetAllProducts(homeDomainRepo: sl()));
  //? cubit
  sl.registerFactory<HomeCubit>(() => HomeCubit(sl()));
  //? Core
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => sharedPreferences);
}
