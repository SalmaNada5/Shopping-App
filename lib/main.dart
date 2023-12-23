import 'package:e_commerce/utils/exports.dart';
import 'package:firebase_core/firebase_core.dart';

import 'di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await di.init();
  runApp(const MyApp());
}

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
        home: const LoginScreen(),
      ),
    );
  }
}
