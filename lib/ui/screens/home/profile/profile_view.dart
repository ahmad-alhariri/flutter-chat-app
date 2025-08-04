import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/viewmodels/profile_viewmodel.dart';
import 'package:flutter_chat_app/core/viewmodels/theme_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    final themeViewModel = context.watch<ThemeViewModel>();
    final currentUser = viewModel.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Column(
        children: [
          SizedBox(height: 30.h),
          CircleAvatar(
            radius: 50.r,
            backgroundImage: currentUser?.photoURL != null
                ? NetworkImage(currentUser!.photoURL!)
                : null,
            child: currentUser?.photoURL == null
                ? Icon(Icons.person, size: 50.r)
                : null,
          ),
          SizedBox(height: 16.h),
          Text(
            currentUser?.displayName ?? 'Anonymous User',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            currentUser?.email ?? 'No email',
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onBackground.withOpacity(0.6)),
          ),
          SizedBox(height: 30.h),
          const Divider(),
          ListTile(
            title: Text('Appearance', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onBackground.withOpacity(0.6))),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('System Default'),
            value: ThemeMode.system,
            groupValue: themeViewModel.themeMode,
            onChanged: (mode) => themeViewModel.setThemeMode(mode!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: themeViewModel.themeMode,
            onChanged: (mode) => themeViewModel.setThemeMode(mode!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: themeViewModel.themeMode,
            onChanged: (mode) => themeViewModel.setThemeMode(mode!),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              onPressed: () => viewModel.signOut(),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
