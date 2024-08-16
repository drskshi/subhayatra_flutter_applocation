import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:subhayatra/firebase_options.dart';
import 'package:subhayatra/global/routing.dart';
import 'package:subhayatra/screens/login_screen.dart';
// import 'package:subhayatra/screens/home_page.dart';
import 'package:subhayatra/screens/register_screen.dart';
// import 'package:subhayatra/splashscreen/splashscreen.dart';
import 'package:subhayatra/themeprovider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'शुभ यात्रा',
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.signIn,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const RegisterScreen(),
    );
  }
}