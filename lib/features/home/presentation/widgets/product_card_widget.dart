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
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill, image: NetworkImage(productImage)),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.all(10),
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
            Align(
              alignment: Alignment.bottomRight,
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
        const SizedBox(
          height: 10,
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
          height: 10,
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
          height: 10,
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
          height: 10,
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
