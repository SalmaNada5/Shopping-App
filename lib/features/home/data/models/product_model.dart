import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? name;
  final String? brand;
  final num? price;
  final String? image;
  final num? rate;
  final num? salePercentage;
  final bool? isSoldOut;
  final String? category;
  final Timestamp? createdAt;

  Product({
    this.name,
    this.brand,
    this.price,
    this.image,
    this.rate,
    this.salePercentage,
    this.isSoldOut,
    this.category,
    this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      brand: json['brand'],
      price: json['price']?.toDouble() ?? 0.0,
      image: json['image'],
      rate: json['rate'],
      salePercentage: json['salePercentage'],
      isSoldOut: json['isSoldOut'],
      category: json['category'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'brand': brand,
      'price': price,
      'image': image,
      'rate': rate,
      'salePercentage': salePercentage,
      'isSoldOut': isSoldOut,
      'category': category,
      'createdAt': createdAt,
    };
  }
}
