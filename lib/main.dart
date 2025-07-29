import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/themes.dart';
import 'package:flutter_chat_app/core/utils/route_utils.dart';
import 'package:flutter_chat_app/ui/screens/splash/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ChatApp());
}


class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        // The theme property is for the light theme.
        theme: AppTheme.lightTheme,
        // The darkTheme property is for the dark theme.
        darkTheme: AppTheme.darkTheme,
        // themeMode controls which theme to use.
        // ThemeMode.system will automatically switch based on the device's setting.
        themeMode: ThemeMode.light,
        onGenerateRoute: RoutUtils.onGenerateRoute,
        home: SplashScreen(),
          ),
        );
  }
}