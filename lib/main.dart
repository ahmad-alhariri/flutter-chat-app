import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/routes.dart';
import 'package:flutter_chat_app/core/constants/themes.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';
import 'package:flutter_chat_app/core/services/database_service.dart';
import 'package:flutter_chat_app/core/services/navigation_service.dart';
import 'package:flutter_chat_app/core/utils/route_utils.dart';
import 'package:flutter_chat_app/core/viewmodels/splash_viewmodel.dart';
import 'package:flutter_chat_app/firebase_options.dart';
import 'package:flutter_chat_app/core/viewmodels/auth_viewmodel.dart';
import 'package:flutter_chat_app/core/viewmodels/chat_list_viewmodel.dart';
import 'package:flutter_chat_app/core/viewmodels/contacts_viewmodel.dart';
import 'package:flutter_chat_app/core/viewmodels/profile_viewmodel.dart';
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

        return MultiProvider(
          providers: [
            // --- SERVICES (These are stateless and can be provided directly) ---
            Provider<NavigationService>(create: (_) => NavigationService()),
            Provider<AuthService>(
              create: (_) => AuthService(FirebaseAuth.instance),
            ),
            Provider<DatabaseService>(
              create: (_) => DatabaseService(FirebaseFirestore.instance),
            ),

            // --- AUTH-INDEPENDENT VIEWMODELS ---
            ChangeNotifierProvider<SplashViewModel>(
              create: (context) => SplashViewModel(
                context.read<AuthService>(),
                context.read<NavigationService>(),
              ),
            ),
            ChangeNotifierProvider<AuthViewModel>(
              create: (context) => AuthViewModel(
                context.read<AuthService>(),
                context.read<DatabaseService>(),
                context.read<NavigationService>(),
              ),
            ),

            // --- AUTH-DEPENDENT VIEWMODELS ---
            StreamProvider<User?>(
              create: (context) => context.read<AuthService>().authStateChanges,
              initialData: null,
            ),
            ChangeNotifierProxyProvider<User?, ChatListViewModel>(
              create: (context) => ChatListViewModel(
                context.read<DatabaseService>(),
                context.read<NavigationService>(),
                context.read<User?>(), // Now reads a nullable User
              ),
              update: (context, user, previousViewModel) => ChatListViewModel(
                context.read<DatabaseService>(),
                context.read<NavigationService>(),
                user, // The new user object (can be null)
              ),
            ),
            ChangeNotifierProxyProvider<User?, ContactsViewModel>(
              create: (context) => ContactsViewModel(
                context.read<DatabaseService>(),
                context.read<NavigationService>(),
                context.read<User?>(), // Now reads a nullable User
              ),
              update: (context, user, previousViewModel) => ContactsViewModel(
                context.read<DatabaseService>(),
                context.read<NavigationService>(),
                user, // The new user object (can be null)
              ),
            ),
            ChangeNotifierProvider<ProfileViewModel>(
              create: (context) => ProfileViewModel(
                context.read<AuthService>(),
                context.read<NavigationService>(),
              ),
            ),
          ],
          child: ScreenUtilInit(
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Chat App',
                // The theme property is for the light theme.
                theme: AppTheme.lightTheme,
                // The darkTheme property is for the dark theme.
                darkTheme: AppTheme.darkTheme,
                // themeMode controls which theme to use.
                // ThemeMode.system will automatically switch based on the device's setting.
                themeMode: ThemeMode.light,
                // The navigatorKey is essential for the NavigationService to work.
                navigatorKey: context.read<NavigationService>().navigatorKey,
                // The onGenerateRoute tells the MaterialApp to use our centralized RouteGenerator.
                onGenerateRoute: RouteGenerator.generateRoute,
                // The initialRoute sets the starting point of the app.
                initialRoute: Routes.splash,
              );
            }
          ),
        );
      }
}
