import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data.dart';
import 'screens/splash_onboarding.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Demo.init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const VexaApp());
}

class VexaApp extends StatelessWidget {
  const VexaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VEXA — AI Fashion Assistant',
      debugShowCheckedModeBanner: false,
      theme: vexaTheme(),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
