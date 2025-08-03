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
              return ConversationInfo(conversation: conversation);
            },
          );
        },
      ),
    );
  }
}

/// A helper widget to fetch the other user's info for a conversation tile.
class ConversationInfo extends StatelessWidget {
  final ConversationModel conversation;
  const ConversationInfo({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    final dbService = context.read<DatabaseService>();
    final authService = context.read<AuthService>();
    final viewModel = context.read<ChatListViewModel>();
    final currentUserId = authService.currentUser?.uid;

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
          onTap: () => viewModel.navigateToChat(otherUser),
        );
      },
    );
  }
}