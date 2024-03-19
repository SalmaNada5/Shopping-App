import 'package:e_commerce/features/home/presentation/cubit/home_cubit.dart';
import 'package:e_commerce/features/home/presentation/widgets/list_item_shimmer_widget.dart';
import 'package:e_commerce/features/home/presentation/widgets/product_card_widget.dart';
import 'package:e_commerce/utils/exports.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthCubit authCubit = BlocProvider.of(context);
    final HomeCubit homeCubit = BlocProvider.of(context);
    homeCubit.getAllProducts();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthHeaderWidget(
                      title: "Welcome back".tr(),
                      fontSize: 22,
                      bottomPadding: 5,
                      topPadding: 0,
                    ),
                    AuthHeaderWidget(
                      title: authCubit.userName ?? "",
                      fontSize: 20,
                      topPadding: 0,
                      bottomPadding: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sale'.tr(),
                      style: const TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 34,
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'View all'.tr(),
                      style: const TextStyle(
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
                    return homeCubit.productsLoading
                        ? Skeletonizer(
                            enabled: homeCubit.productsLoading,
                            child: SizedBox(
                              height: 200,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: 4,
                                itemBuilder: (context, index) =>
                                    const ListItemShimmerWidget(),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  width: 10,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: homeCubit.productsList?.length ?? 1,
                              itemBuilder: (context, index) =>
                                  ProductCardWidget(
                                rate: homeCubit.productsList?[index].rate
                                        ?.toDouble() ??
                                    0,
                                brand:
                                    homeCubit.productsList?[index].brand ?? "",
                                name: homeCubit.productsList?[index].name ?? "",
                                price:
                                    homeCubit.productsList?[index].price ?? 0,
                                productImage:
                                    homeCubit.productsList?[index].image ?? "",
                                //isInFavorites: true,
                                sale: homeCubit
                                        .productsList?[index].salePercenage ??
                                    1,
                              ),
                            ),
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
