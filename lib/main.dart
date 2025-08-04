import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/routes.dart';
import 'package:flutter_chat_app/core/constants/themes.dart';
import 'package:flutter_chat_app/core/providers/app_provider.dart';
import 'package:flutter_chat_app/core/services/navigation_service.dart';
import 'package:flutter_chat_app/core/utils/route_utils.dart';
import 'package:flutter_chat_app/core/viewmodels/theme_viewmodel.dart';
import 'package:flutter_chat_app/firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});
  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          // Consume the ThemeViewModel to reactively update the theme.
          final themeViewModel = context.watch<ThemeViewModel>();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chat App',
            // The theme property is for the light theme.
            theme: AppTheme.lightTheme,
            // The darkTheme property is for the dark theme.
            darkTheme: AppTheme.darkTheme,
            // themeMode controls which theme to use.
            themeMode: themeViewModel.themeMode,
            // The navigatorKey is essential for the NavigationService to work.
            navigatorKey: context.read<NavigationService>().navigatorKey,
            // The onGenerateRoute tells the MaterialApp to use our centralized RouteGenerator.
            onGenerateRoute: RouteGenerator.generateRoute,
            // The initialRoute sets the starting point of the app.
            initialRoute: Routes.splash,
          );
        },
      ),
    );
  }
}
