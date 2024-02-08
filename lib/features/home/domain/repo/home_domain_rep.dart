import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:e_commerce/utils/exports.dart';

abstract class HomeDomainRepo {
  Either<Failure, List<Product>?> getAllProducts();
}
