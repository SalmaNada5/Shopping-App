import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/exceptions.dart';
import 'package:e_commerce/core/errors/failures.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:e_commerce/features/home/data/source/remote_source/home_remote_source.dart';
import 'package:e_commerce/features/home/domain/repo/home_domain_rep.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeDataRepo implements HomeDomainRepo {
  final HomeRemoteSource homeRemoteSource;

  HomeDataRepo({required this.homeRemoteSource});
  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async{
    try {
      final products = await homeRemoteSource.getAllProductsFunction();
      if (products != null) {
        return Right(products);
      } else {
        return const Left(OfflineFailure(message: "Can't get products"));
      }
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure(message: e.code));
    } on OfflineException catch (e) {
      return Left(OfflineFailure(message: e.message));
    }
  }
}
