import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/features/home/settings/widgets/change_language_widget.dart';
import 'package:e_commerce/utils/exports.dart';
import 'package:easy_localization/easy_localization.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentPageIndex = 0;
  void onChangeIndex(int? index) {
    setState(() {
      _currentPageIndex = index ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    final HomeCubit homeCubit = BlocProvider.of<HomeCubit>(context);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          onTap: onChangeIndex,
          currentIndex: _currentPageIndex,
          unselectedItemColor: const Color(0xFF9B9B9B),
          selectedItemColor: const Color(0xFFDB3022),
          elevation: 20,
          type: BottomNavigationBarType.fixed,
          // selectedLabelStyle: const TextStyle(
          //   color: Color(0xFFDB3022),
          //   fontSize: 10,
          //   fontFamily: 'Metropolis',
          //   fontWeight: FontWeight.w400,
          // ),
          // unselectedLabelStyle: const TextStyle(
          //   color: Color(0xFF9B9B9B),
          //   fontSize: 10,
          //   fontFamily: 'Metropolis',
          //   fontWeight: FontWeight.w400,
          // ),
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentPageIndex == 0
                    ? 'assets/images/home_active.svg'
                    : 'assets/images/home.svg',
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentPageIndex == 1
                    ? 'assets/images/shop_active.svg'
                    : 'assets/images/shop.svg',
              ),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentPageIndex == 2
                    ? 'assets/images/bag_active.svg'
                    : 'assets/images/bag.svg',
              ),
              label: 'Bag',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentPageIndex == 3
                    ? 'assets/images/fav_activated.svg'
                    : 'assets/images/fav.svg',
              ),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentPageIndex == 4
                    ? 'assets/images/profile_active.svg'
                    : 'assets/images/profile.svg',
              ),
              label: 'Profile',
            ),
          ]),
      body: IndexedStack(
        index: _currentPageIndex,
        children: [
          const HomePage(),
          const Center(),
          const Center(),
          const Center(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Change Language'.tr(),
                      style: const TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 16,
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const ChangeLanguageWidget(),
                  ],
                ),
                TextButton(
                    style: const ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(Colors.red)),
                    onPressed: () => authCubit.signOutFunction(),
                    child: const Text('LOGOUT')),
                TextButton(
                    onPressed: () => homeCubit.addProduct(Product(
                          name: 'Gray Pants',
                          brand: 'Mango',
                          rate: 3,
                          price: 10,
                          image:
                              'https://images.unsplash.com/photo-1506629082955-511b1aa562c8?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fHBhbnRzfGVufDB8fDB8fHww',
                          salePercentage: 1,
                          isSoldOut: false,
                          category: 'women',
                          createdAt: Timestamp.now(),
                        )),
                    child: const Text('Add'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
