import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:e_commerce/features/home/domain/usecases/get_all_products.dart';
import 'package:e_commerce/utils/exports.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getAllProducts) : super(HomeInitial());
  final GetAllProducts _getAllProducts;
  List<Product> productsList = [];
  void getAllProducts() {
    emit(HomeInitial());
    final Either<Failure, List<Product>?> res = _getAllProducts();
    emit(_getAllProductsSuccessOrFailureState(res));
  }

  HomeState _getAllProductsSuccessOrFailureState(
      Either<Failure, List<Product>?> res) {
    return res.fold((l) {
      logError("error in getAllProducts: ${l.message}");
      return GetAllProductsFailure();
    }, (r) {
      productsList = r ?? [];
      logSuccess("products returned successfully: $r");
      return GetAllProductsSuccess();
    });
  }
}
