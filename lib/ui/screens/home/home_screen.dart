import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/models/conversation_model.dart';
import 'package:flutter_chat_app/core/models/message_model.dart';
import 'package:flutter_chat_app/core/models/user_model.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';
import 'package:flutter_chat_app/core/services/database_service.dart';
import 'package:flutter_chat_app/ui/screens/auth/auth_viewmodel.dart';
import 'package:flutter_chat_app/ui/screens/chat/chat_screen.dart';
import 'package:flutter_chat_app/ui/screens/home/chat_viewmodel.dart';
import 'package:flutter_chat_app/ui/screens/home/chats_viewmodel.dart';
import 'package:flutter_chat_app/ui/screens/home/contacts_viewmodel.dart';
import 'package:flutter_chat_app/ui/screens/home/main_viewmodel.dart';
import 'package:flutter_chat_app/ui/screens/home/profile_viewmodel.dart';
import 'package:flutter_chat_app/ui/widgets/conversation_tile_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
                ChatsScreen(),
                ContactsScreen(),
                ProfileScreen(),
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


class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatsViewModel>();
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            // Placeholder for user profile picture
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'),
          ),
        ),
        title: const Text('Chats', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: StreamBuilder<List<ConversationModel>>(
        stream: viewModel.conversationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No conversations yet.'));
          }
          final conversations = snapshot.data!;
          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return ConversationInfo(conversation: conversation);
            },
          );
        },
      ),
    );
  }
}

// Helper widget to fetch other user's info
class ConversationInfo extends StatelessWidget {
  final ConversationModel conversation;
  const ConversationInfo({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    final dbService = context.read<DatabaseService>();
    final authService = context.read<AuthService>();
    final currentUserId = authService.currentUser?.uid;

    // Find the other participant's ID
    final otherUserId = conversation.participantIds.firstWhere((id) => id != currentUserId, orElse: () => '');

    if (otherUserId.isEmpty) return const SizedBox.shrink();

    return FutureBuilder<UserModel?>(
      future: dbService.getUser(otherUserId),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const ListTile(title: Text("Loading..."));
        }
        final otherUser = userSnapshot.data!;
        return ConversationTile(
          otherUser: otherUser,
          lastMessage: conversation.lastMessage,
          lastMessageTimestamp: conversation.lastMessageTimestamp.toDate(),
          unreadCount: conversation.unreadCount,
        );
      },
    );
  }
}

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ContactsViewModel>();
    final dbService = context.read<DatabaseService>();
    final currentUserId = context.read<AuthService>().currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: StreamBuilder<List<UserModel>>(
        stream: viewModel.usersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          }
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.username),
                subtitle: Text(user.email),
                onTap: () async {
                  if (currentUserId == null) return;
                  final conversationId = await dbService.createOrGetConversation(currentUserId, user.uid);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ChatScreen(conversationId: conversationId, otherUser: user),
                  ));
                },
              );
            },
          );
        },
      ),
    );
  }
}


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    final currentUser = viewModel.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Username: ${currentUser?.displayName ?? 'N/A'}'),
            Text('Email: ${currentUser?.email ?? 'N/A'}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await viewModel.signOut();
                // The main listener will handle navigation
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
