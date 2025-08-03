import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';
import 'package:flutter_chat_app/core/services/database_service.dart';
import 'package:flutter_chat_app/core/services/navigation_service.dart';
import 'package:flutter_chat_app/core/viewmodels/auth_viewmodel.dart';
import 'package:flutter_chat_app/core/viewmodels/chat_list_viewmodel.dart';
import 'package:flutter_chat_app/core/viewmodels/contacts_viewmodel.dart';
import 'package:flutter_chat_app/core/viewmodels/profile_viewmodel.dart';
import 'package:flutter_chat_app/core/viewmodels/splash_viewmodel.dart';
import 'package:provider/provider.dart';

// ==================================================
// PURPOSE: Centralizes all dependency injection providers for the app.
// This cleans up the main.dart file and makes provider management easier.
// ==================================================
class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

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
            context.read<User?>(),
          ),
          update: (context, user, previousViewModel) => ChatListViewModel(
            context.read<DatabaseService>(),
            context.read<NavigationService>(),
            user,
          ),
        ),
        ChangeNotifierProxyProvider<User?, ContactsViewModel>(
          create: (context) => ContactsViewModel(
            context.read<DatabaseService>(),
            context.read<NavigationService>(),
            context.read<User?>(),
          ),
          update: (context, user, previousViewModel) => ContactsViewModel(
            context.read<DatabaseService>(),
            context.read<NavigationService>(),
            user,
          ),
        ),
        ChangeNotifierProvider<ProfileViewModel>(
          create: (context) => ProfileViewModel(
            context.read<AuthService>(),
            context.read<NavigationService>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
