import 'package:flutter/material.dart';
import 'package:subhayatra/screens/login_screen.dart';
import 'package:subhayatra/screens/register_screen.dart';
import '';
import '';
import '';

class AppRoutes {
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String forgetPassword = '/forgetpassword';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(builder: (c) => const LoginScreen());
      case signUp:
        return MaterialPageRoute(builder: (c) => RegisterScreen());
      // case forgetPassword:
      //   return MaterialPageRoute(builder: (_) => ForgetPasswordScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
