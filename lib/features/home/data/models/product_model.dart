class Product {
  final String? id;
  final String? name;
  final String? brand;
  final num? price;
  final String? image;
  final bool? isNew;
  final bool? isSale;
  final num? rate;
  final num? salePercenage;
  final bool? isSoldOut;
  final String? type;

  Product({
    this.id,
    this.name,
    this.brand,
    this.price,
    this.image,
    this.isNew,
    this.isSale,
    this.rate,
    this.salePercenage,
    this.isSoldOut,
    this.type,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        id: map['id'],
        name: map['name'],
        brand: map['brand'],
        price: map['price']?.toDouble() ?? 0.0,
        image: map['image'],
        isNew: map['isNew'],
        isSale: map['isSale'],
        rate: map['rate'],
        salePercenage: map['salePercentage'],
        isSoldOut: map['isSoldOut'],
        type: map['type']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'price': price,
      'image': image,
      'isNew': isNew,
      'isSale': isSale,
      'rate': rate,
      'salePercenage': salePercenage,
      'isSoldOut': isSoldOut,
      'type': type,
    };
  }
}
