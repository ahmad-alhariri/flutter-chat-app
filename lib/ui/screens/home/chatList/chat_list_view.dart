import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';
import 'package:flutter_chat_app/core/viewmodels/chat_list_viewmodel.dart';
import 'package:flutter_chat_app/ui/widgets/conversation_tile_widget.dart';
import 'package:flutter_chat_app/ui/widgets/empty_state_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

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
    final viewModel = context.watch<ChatListViewModel>();
    final authService = context.read<AuthService>();

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: authService.currentUser?.photoURL != null
                ? NetworkImage(authService.currentUser!.photoURL!)
                : null,
          ),
        ),
        title: const Text('Chats', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.add), onPressed: () => _showNewChatMenu(context)),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (viewModel.isBusy) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.conversations.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.chat_bubble_outline,
              title: 'No Conversations Yet',
              message: 'Tap the "+" button to start a new chat with a contact.',
            );
          }
          final conversations = viewModel.conversations;
          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              final currentUserId = authService.currentUser?.uid;
              final otherUserId = conversation.participantIds.firstWhere((id) => id != currentUserId, orElse: () => '');

              if (otherUserId.isEmpty) return const SizedBox.shrink();

              final otherUser = viewModel.userCache[otherUserId];

              return ConversationTile(
                otherUser: otherUser,
                lastMessage: conversation.lastMessage,
                lastMessageTimestamp: conversation.lastMessageTimestamp.toDate(),
                unreadCount: conversation.unreadCount,
                onTap: () {
                  if (otherUser != null) {
                    viewModel.navigateToChat(otherUser);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}