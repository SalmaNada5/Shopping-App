import 'package:e_commerce/utils/exports.dart';
import 'package:e_commerce/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({
    super.key,
    this.sale = 1,
    required this.rate,
    required this.brand,
    required this.name,
    required this.price,
    required this.productImage,
    this.isNew = false,
  });
  final num sale;
  final double rate;
  final String brand;
  final String name;
  final num price;
  final String productImage;
  final bool? isNew;
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
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  productImage,
                  width: context.screenWidth * 0.25,
                  height: 110,
                  fit: BoxFit.fill,
                  errorBuilder: (context, url, error) =>
                      Image.asset("assets/images/placeholder.png"),
                ),
              ),
              Positioned(
                top: 5,
                left: 5,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        sale != 1 && isNew != true ? Colors.red : Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    sale != 1 && isNew != true ? "-$sale%" : "New",
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
                    //TODO handle add item to favorites
                    child: const Icon(
                      CupertinoIcons.heart_fill,
                      color: Colors.red,
                      size: 16,
                    )
                    // : const Icon(
                    //     CupertinoIcons.heart,
                    //     color: Colors.grey,
                    //     size: 16,
                    //   ),
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
        if (sale != 1 && isNew != true) ...{
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
