import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/utils/exports.dart';
import 'package:e_commerce/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget(
      {super.key,
      this.sale = 1,
      required this.rate,
      required this.brand,
      required this.name,
      required this.price,
      required this.productImage,
      this.isInFavorites = false});
  final num sale;
  final double rate;
  final String brand;
  final String name;
  final num price;
  final String productImage;
  final bool isInFavorites;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 120,
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: productImage,
                width: context.screenWidth * 0.3,
                height: 110,
                fit: BoxFit.contain,
                imageBuilder: (context, imageProvider) => ClipRRect(borderRadius: BorderRadius.circular(12),),
                placeholder: (context, url) =>
                    Image.asset("assets/images/placeholder.png"),
              ),
              Positioned(
                top: 5,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: sale != 1 ? Colors.red : Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    sale != 1 ? "-$sale%" : "New",
                    style: const TextStyle(
                      color: Color(0xffffffff),
                      fontSize: 14,
                      fontFamily: 'Metropolis',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 5,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        )
                      ],
                      color: Colors.white),
                  child: isInFavorites
                      ? const Icon(
                          CupertinoIcons.heart_fill,
                          color: Colors.red,
                          size: 16,
                        )
                      : const Icon(
                          CupertinoIcons.heart,
                          color: Colors.grey,
                          size: 16,
                        ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RatingBarIndicator(
              itemCount: 5,
              rating: rate,
              unratedColor: const Color.fromARGB(255, 205, 199, 199),
              itemSize: 12,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "($rate)",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontFamily: 'Metropolis',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          brand,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontFamily: 'Metropolis',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xff000000),
            fontSize: 16,
            fontFamily: 'Metropolis',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        if (sale != 1) ...{
          Row(
            children: [
              Text(
                "$price\$",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontFamily: 'Metropolis',
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                "${price - (price * (sale / 100))}\$",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontFamily: 'Metropolis',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        } else ...{
          Text(
            "$price\$",
            style: const TextStyle(
              color: Color(0xff000000),
              fontSize: 14,
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.w500,
            ),
          ),
        }
      ],
    );
  }
}
