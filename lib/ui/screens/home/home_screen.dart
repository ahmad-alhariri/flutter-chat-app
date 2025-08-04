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
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: viewModel.currentIndex,
              onTap: viewModel.onTabTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_outline),
                  activeIcon: Icon(Icons.chat_bubble),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_outline),
                  activeIcon: Icon(Icons.people),
                  label: 'Contacts',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

