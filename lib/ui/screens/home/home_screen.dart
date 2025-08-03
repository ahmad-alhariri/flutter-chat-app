import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/models/conversation_model.dart';
import 'package:flutter_chat_app/core/models/user_model.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';
import 'package:flutter_chat_app/core/services/database_service.dart';
import 'package:flutter_chat_app/core/viewmodels/chat_list_viewmodel.dart';
import 'package:flutter_chat_app/core/viewmodels/contacts_viewmodel.dart';
import 'package:flutter_chat_app/core/viewmodels/main_viewmodel.dart';
import 'package:flutter_chat_app/core/viewmodels/profile_viewmodel.dart';
import 'package:flutter_chat_app/ui/screens/home/chatList/chat_list_view.dart';
import 'package:flutter_chat_app/ui/screens/home/contacts/contacts_view.dart';
import 'package:flutter_chat_app/ui/screens/home/profile/profile_view.dart';
import 'package:flutter_chat_app/ui/widgets/conversation_tile_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// ==================================================
// PURPOSE: The main hub of the app for a logged-in user. It contains the
// BottomNavigationBar and manages the different pages (Chats, Contacts, Profile).
// ==================================================
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  void _showNewChatMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.chat_bubble_outline),
                title: const Text('New Chat'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to a new chat creation screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_add_alt_1_outlined),
                title: const Text('New Contact'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to a new contact creation screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.group_add_outlined),
                title: const Text('New Community'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to a new community creation screen
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainViewModel(),
      child: Consumer<MainViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: PageView(
              controller: viewModel.pageController,
              onPageChanged: viewModel.onPageChanged,
              children: const [
                ChatListView(),
                ContactsView(),
                ProfileView(),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showNewChatMenu(context),
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.home_outlined),
                    onPressed: () => viewModel.onTabTapped(0),
                    color: viewModel.currentIndex == 0 ? Theme.of(context).colorScheme.primary : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.people_alt_outlined),
                    onPressed: () => viewModel.onTabTapped(1),
                    color: viewModel.currentIndex == 1 ? Theme.of(context).colorScheme.primary : null,
                  ),
                  const SizedBox(width: 40), // The space for the FAB
                  IconButton(
                    icon: const Icon(Icons.call_outlined),
                    onPressed: () { /* TODO: Implement Calls Screen */ },
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline),
                    onPressed: () => viewModel.onTabTapped(2),
                    color: viewModel.currentIndex == 2 ? Theme.of(context).colorScheme.primary : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

