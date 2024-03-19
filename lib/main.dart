import 'package:e_commerce/app.dart';
import 'package:e_commerce/utils/exports.dart';
import 'package:easy_localization/easy_localization.dart';
import 'di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ar')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    child: const MyApp()));
}

