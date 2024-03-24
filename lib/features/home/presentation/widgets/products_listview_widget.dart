import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:e_commerce/features/home/presentation/widgets/product_card_widget.dart';
import 'package:flutter/material.dart';

class ProductsListViewWidget extends StatelessWidget {
  const ProductsListViewWidget(
      {super.key, required this.productsList, this.newProducts = false});
  final List<Product>? productsList;
  final bool? newProducts;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
          width: 10,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: productsList?.length ?? 1,
        itemBuilder: (context, index) => ProductCardWidget(
          rate: productsList?[index].rate?.toDouble() ?? 0,
          brand: productsList?[index].brand ?? "",
          name: productsList?[index].name ?? "",
          price: productsList?[index].price ?? 0,
          productImage: productsList?[index].image ?? "",
          sale: productsList?[index].salePercentage ?? 10,
          isNew: newProducts,
        ),
      ),
    );
  }
}
