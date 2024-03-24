import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/errors/exceptions.dart';
import 'package:e_commerce/utils/exports.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class HomeRemoteSource {
  Future<List<Product>>? getAllProductsFunction();
}

class HomeRemoteSourceImlp implements HomeRemoteSource {
  @override
  Future<List<Product>>? getAllProductsFunction() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Product.fromJson(data);
      }).toList();
    } catch (e) {
      logError("error in getAllProductsFunction: $e}");
      if (e is FirebaseAuthException) {
        throw FirebaseAuthException(code: e.code);
      } else {
        throw OfflineException('$e');
      }
    }
  }
}
