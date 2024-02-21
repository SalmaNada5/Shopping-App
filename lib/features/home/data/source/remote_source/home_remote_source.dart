import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/errors/exceptions.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:e_commerce/utils/exports.dart';

abstract class HomeRemoteSource {
  Future<List<Product>>? getAllProductsFunction();
}

class HomeRemoteSourceImlp implements HomeRemoteSource {
  @override
  Future<List<Product>>? getAllProductsFunction() async {
    List<Product> products = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        products.add(
          Product(
              id: doc.id,
              name: data['name'],
              brand: data['brand'],
              price: data['price']?.toDouble() ?? 0.0,
              isNew: data['isNew'],
              isSale: data['isSale'],
              isSoldOut: data['isSoldOut'],
              image: data['image'],
              rate: data['rate'],
              category: data['category']),
        );
      }
      return products;
    } catch (e) {
      logError("error in getAllProductsFunction: $e}");
      if (e is FirebaseAuthException) {
        throw FirebaseAuthException(e.message);
      } else {
        throw OfflineException('$e');
      }
    }
  }
}
