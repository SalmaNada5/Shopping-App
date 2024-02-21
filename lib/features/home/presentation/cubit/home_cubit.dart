import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
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

//? add new product to collection
  void addProduct() {
    FirebaseFirestore.instance.collection('products').add({
      'name': 'Product Name',
      'description': 'Product Description',
      'price': 19.99,
      'imageUrl': 'https://example.com/product.jpg',
      'category': 'Electronics',
      'brand': '',
      'sale': 15,
    }).then((value) {
      logInfo("Product Added");
    }).catchError((error) {
      logError("Failed to add product: $error");
    });
  }
}
