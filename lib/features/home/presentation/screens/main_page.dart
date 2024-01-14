import 'package:e_commerce/utils/exports.dart';
import 'package:flutter_svg/svg.dart';

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
            child: TextButton(
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.red)),
                onPressed: () => authCubit.signOutFunction(),
                child: const Text('LOGOUT')),
          ),
        ],
      ),
    );
  }
}
