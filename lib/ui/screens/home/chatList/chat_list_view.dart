import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/models/conversation_model.dart';
import 'package:flutter_chat_app/core/models/user_model.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';
import 'package:flutter_chat_app/core/services/database_service.dart';
import 'package:flutter_chat_app/core/viewmodels/chat_list_viewmodel.dart';
import 'package:flutter_chat_app/ui/widgets/conversation_tile_widget.dart';
import 'package:flutter_chat_app/ui/widgets/empty_state_widget.dart';
import 'package:provider/provider.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

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
        ],
      ),
      body: StreamBuilder<List<ConversationModel>>(
        stream: viewModel.conversationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const EmptyStateWidget(
              icon: Icons.error_outline,
              title: 'Something Went Wrong',
              message: 'We couldn\'t load your conversations. Please try again later.',
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.chat_bubble_outline,
              title: 'No Conversations Yet',
              message: 'Tap the "+" button to start a new chat with a contact.',
            );
          }
          final conversations = snapshot.data!;
          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              final currentUserId = authService.currentUser?.uid;
              final otherUserId = conversation.participantIds.firstWhere((id) => id != currentUserId, orElse: () => '');

              if (otherUserId.isEmpty) return const SizedBox.shrink();

              // Get the user data from the ViewModel's cache.
              final otherUser = viewModel.userCache[otherUserId];

              return ConversationTile(
                otherUser: otherUser, // Can be null while loading
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