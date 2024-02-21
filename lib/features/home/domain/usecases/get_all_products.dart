import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:e_commerce/features/home/domain/repo/home_domain_rep.dart';
import 'package:e_commerce/utils/exports.dart';

class GetAllProducts {
  final HomeDomainRepo homeDomainRepo;

  GetAllProducts({required this.homeDomainRepo});

  Future<Either<Failure, List<Product>>> call() => homeDomainRepo.getAllProducts();
}
