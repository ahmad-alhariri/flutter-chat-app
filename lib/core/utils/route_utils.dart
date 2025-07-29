import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/paths.dart';
import 'package:flutter_chat_app/ui/screens/home/home_screen.dart';
import 'package:flutter_chat_app/ui/screens/splash/splash_screen.dart';

class RoutUtils{
  static Route<dynamic?> onGenerateRoute(RouteSettings settings){
    switch(settings.name){
      case splash:
        return MaterialPageRoute(builder: (context) => SplashScreen());
        case home:
          return MaterialPageRoute(builder: (context) => HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text("No Route Found")),
          ),
        );
    }
  }
}