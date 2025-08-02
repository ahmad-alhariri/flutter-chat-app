import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/models/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ConversationTile extends StatelessWidget {
  final UserModel otherUser;
  final String lastMessage;
  final DateTime lastMessageTimestamp;
  final int unreadCount;

  const ConversationTile({
    super.key,
    required this.otherUser,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: CircleAvatar(
        radius: 28.r,
        backgroundImage: otherUser.profileImageUrl != null
            ? NetworkImage(otherUser.profileImageUrl!)
            : null,
        child: otherUser.profileImageUrl == null
            ? Text(
          otherUser.username.isNotEmpty ? otherUser.username[0] : '?',
          style: TextStyle(fontSize: 24.sp, color: Colors.white),
        )
            : null,
        backgroundColor: theme.colorScheme.secondary,
      ),
      title: Text(
        otherUser.username,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onBackground.withOpacity(0.6),
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            DateFormat('hh:mm a').format(lastMessageTimestamp),
            style: theme.textTheme.bodySmall,
          ),
          if (unreadCount > 0) ...[
            SizedBox(height: 4.h),
            CircleAvatar(
              radius: 10.r,
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                unreadCount.toString(),
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () {
        // TODO: Navigate to chat screen
      },
    );
  }
}
