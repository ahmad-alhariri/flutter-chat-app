import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/models/user_model.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';
import 'package:flutter_chat_app/core/services/database_service.dart';
import 'package:flutter_chat_app/core/viewmodels/chat_viewmodel.dart';
import 'package:flutter_chat_app/ui/widgets/empty_state_widget.dart';
import 'package:flutter_chat_app/ui/widgets/message_bubble_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final UserModel otherUser;

  const ChatScreen({
    super.key,
    required this.otherUser,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Future<String> _conversationIdFuture;

  @override
  void initState() {
    super.initState();
    // Fetch the conversation ID when the screen is first created.
    final dbService = context.read<DatabaseService>();
    final currentUserId = context.read<AuthService>().currentUser?.uid;
    _conversationIdFuture = dbService.createOrGetConversation(currentUserId!, widget.otherUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _conversationIdFuture,
      builder: (context, snapshot) {
        // Show a loading indicator while fetching the conversation ID.
        if (!snapshot.hasData) {
          return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
        }
        final conversationId = snapshot.data!;
        // Once the ID is available, provide the ChatViewModel and build the screen.
        return ChangeNotifierProvider(
          create: (context) => ChatViewModel(
            context.read(),
            context.read(),
            conversationId,
          ),
          child: _ChatScreenContent(otherUser: widget.otherUser),
        );
      },
    );
  }
}

/// The main content of the chat screen, which is lifecycle-aware.
class _ChatScreenContent extends StatefulWidget {
  final UserModel otherUser;
  const _ChatScreenContent({required this.otherUser});

  @override
  State<_ChatScreenContent> createState() => _ChatScreenContentState();
}

class _ChatScreenContentState extends State<_ChatScreenContent> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Add an observer to listen for app lifecycle changes.
    WidgetsBinding.instance.addObserver(this);
    // Mark messages as seen when the screen is first built.
    context.read<ChatViewModel>().markMessagesAsSeen();
  }

  @override
  void dispose() {
    // It's crucial to remove the observer to prevent memory leaks.
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // When the app is resumed (brought to the foreground), mark messages as seen.
    if (state == AppLifecycleState.resumed) {
      context.read<ChatViewModel>().markMessagesAsSeen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.otherUser.profileImageUrl != null
                  ? NetworkImage(widget.otherUser.profileImageUrl!)
                  : null,
              child: widget.otherUser.profileImageUrl == null
                  ? Text(widget.otherUser.username.isNotEmpty ? widget.otherUser.username[0] : '?')
                  : null,
            ),
            SizedBox(width: 12.w),
            Text(widget.otherUser.username),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                if (viewModel.isBusy) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (viewModel.messages.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.waving_hand_outlined,
                    title: 'Say Hi!',
                    message: 'Be the first to send a message.',
                  );
                }
                final messages = viewModel.messages;
                return ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == viewModel.currentUserId;
                    return MessageBubble(
                      text: message.text,
                      isMe: isMe,
                      status:message.status,
                    );
                  },
                );
              },
            ),
          ),
          _MessageInputField(),
        ],
      ),
    );
  }
}

class _MessageInputField extends StatefulWidget {
  @override
  __MessageInputFieldState createState() => __MessageInputFieldState();
}

class __MessageInputFieldState extends State<_MessageInputField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      context.read<ChatViewModel>().sendMessage(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -2),
              blurRadius: 10,
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            SizedBox(width: 8.w),
            FloatingActionButton(
              mini: true,
              onPressed: _sendMessage,
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}