import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/home/domain/usecases/get_all_products.dart';
import 'package:e_commerce/utils/exports.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getAllProducts) : super(HomeInitial());
  final GetAllProducts _getAllProducts;
  List<Product>? productsList;
  bool productsLoading = false;
  void getAllProducts() async {
    emit(HomeInitial());
    productsLoading = true;
    final Either<Failure, List<Product>> res = await _getAllProducts();
    productsLoading = false;
    emit(_getAllProductsSuccessOrFailureState(res));
  }

  HomeState _getAllProductsSuccessOrFailureState(
      Either<Failure, List<Product>> res) {
    return res.fold((l) {
      return GetAllProductsFailure();
    }, (r) {
      productsList = r;
      logSuccess(
          "products returned successfully: $r , ${productsList?.length}");
      return GetAllProductsSuccess();
    });
  }

  List<Product> getOnSaleProducts() {
    return productsList
            ?.where((product) => product.salePercentage != 1)
            .toList() ??
        [];
  }

  List<Product> getNewProducts() {
    final now = Timestamp.now();
    const thresholdDuration = Duration(days: 7);
    return productsList
            ?.where((product) =>
                product.createdAt
                    ?.toDate()
                    .isAfter(now.toDate().subtract(thresholdDuration)) ??
                false)
            .toList() ??
        [];
  }

//? add new product to collection (admin)
  Future<void> addProduct(Product product) async {
    try {
      CollectionReference products =
          FirebaseFirestore.instance.collection('products');
      Map<String, dynamic> productData = product.toJson();
      await products.add(productData);
      logWarning('Product added successfully');
    } catch (e) {
      logError('Error adding product: $e');
    }
  }
}
