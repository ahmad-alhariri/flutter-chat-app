import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ui/screens/auth/auth_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // Call the ViewModel to handle the sign-out logic
                Provider.of<AuthViewModel>(context, listen: false).signOut();
              },
            ),
          ]
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome!', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 28.sp)),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}