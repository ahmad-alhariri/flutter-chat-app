import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/themes.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';
import 'package:flutter_chat_app/core/utils/route_utils.dart';
import 'package:flutter_chat_app/firebase_options.dart';
import 'package:flutter_chat_app/ui/screens/splash/splash_screen.dart';
import 'package:flutter_chat_app/ui/screens/splash/splash_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      builder: (context, child) {
        return MultiProvider(
          providers: [
            // Provide the AuthService instance.
            Provider<AuthService>(
              create: (_) => AuthService(FirebaseAuth.instance),
            ),
            // Provide the SplashViewModel, which depends on AuthService.
            ChangeNotifierProvider<SplashViewModel>(
              create: (context) => SplashViewModel(context.read<AuthService>()),
            ),
          ],
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
      },
    );
  }
}
