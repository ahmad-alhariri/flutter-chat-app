import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/models/user_model.dart';
import 'package:flutter_chat_app/ui/screens/home/chat_viewmodel.dart';
import 'package:flutter_chat_app/ui/widgets/message_bubble_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/models/message_model.dart';

class ChatScreen extends StatelessWidget {
  final String conversationId;
  final UserModel otherUser;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.otherUser,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatViewModel(
        context.read(),
        context.read(),
        conversationId,
      ),
      child: Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: otherUser.profileImageUrl != null
                        ? NetworkImage(otherUser.profileImageUrl!)
                        : null,
                    child: otherUser.profileImageUrl == null
                        ? Text(otherUser.username.isNotEmpty ? otherUser.username[0] : '?')
                        : null,
                  ),
                  SizedBox(width: 12.w),
                  Text(otherUser.username),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<MessageModel>>(
                    stream: viewModel.messagesStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("Say hi!"));
                      }
                      final messages = snapshot.data!;
                      return ListView.builder(
                        reverse: true,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.senderId == viewModel.currentUserId;
                          return MessageBubble(text: message.text, isMe: isMe);
                        },
                      );
                    },
                  ),
                ),
                _MessageInputField(),
              ],
            ),
          );
        },
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
