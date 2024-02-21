import 'package:e_commerce/features/home/presentation/cubit/home_cubit.dart';
import 'package:e_commerce/features/home/presentation/widgets/product_card_widget.dart';
import 'package:e_commerce/utils/exports.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = BlocProvider.of(context, listen: false);
    HomeCubit homeCubit = BlocProvider.of(context, listen: false);
    homeCubit.getAllProducts();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Image.network(
                        authCubit.userPhotoUrl ?? '',
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) =>
                            SvgPicture.asset("assets/images/profile.svg"),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AuthHeaderWidget(
                          title: "Welcome back,",
                          fontSize: 22,
                          bottomPadding: 5,
                          topPadding: 0,
                        ),
                        AuthHeaderWidget(
                          title: authCubit.userName ?? "",
                          fontSize: 20,
                          topPadding: 0,
                          bottomPadding: 0,
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sale',
                      style: TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 34,
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'View all',
                      style: TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 11,
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                BlocBuilder<HomeCubit, HomeState>(
                    bloc: homeCubit,
                    builder: (context, state) {
                      return SizedBox(
                        height: 200,
                        child: Skeleton.leaf(
                          enabled: homeCubit.productsLoading,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: homeCubit.productsList?.length ?? 4,
                            itemBuilder: (context, index) => ProductCardWidget(
                              rate: homeCubit.productsList?[index].rate
                                      ?.toDouble() ??
                                  0,
                              brand: homeCubit.productsList?[index].brand ?? "",
                              name: homeCubit.productsList?[index].name ?? "",
                              price: homeCubit.productsList?[index].price ?? 0,
                              productImage:
                                  homeCubit.productsList?[index].image ?? "",
                              //isInFavorites: homeCubit.productsList[0],
                              sale: homeCubit
                                      .productsList?[index].salePercenage ??
                                  1,
                            ),
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
