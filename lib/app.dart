import 'package:e_commerce/utils/exports.dart';

import 'di.dart' as di;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: di.sl()),
      ],
      child: MaterialApp(
        navigatorKey: Constants.navigatorKey,
        theme: ThemeData(
          useMaterial3: false,
          primaryColor: const Color(0xffDB3022),
        ),
        home: const SignUpScreen(),
      ),
    );
  }
}
