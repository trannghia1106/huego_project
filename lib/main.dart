import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hue_go/providers/tour_provider.dart';
import 'package:hue_go/providers/yeuthich_provider.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './View/login.dart';
import './providers/diadiem_provider.dart';
import './providers/user_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //   )
  // );
  await initializeDateFormatting('vi_VN', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DiadiemProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => YeuThichProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TourProvider(),
        ),
      ],
      child: const MyHueGo(),
    ),
  );
}


class MyHueGo extends StatelessWidget {
  const MyHueGo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: login(),
    );
  }
}

