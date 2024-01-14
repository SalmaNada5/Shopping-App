import 'package:e_commerce/app.dart';
import 'package:e_commerce/utils/exports.dart';
import 'package:firebase_core/firebase_core.dart';

import 'di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await di.init();
  runApp(const MyApp());
}

