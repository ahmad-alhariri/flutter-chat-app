import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/firestore_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ==================================================
// PURPOSE: A widget that displays a single chat message, styled differently
// based on whether it was sent by the current user or the other user.
// ==================================================
class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String status;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.status,
  });

  Widget _buildStatusIcon(BuildContext context) {
    final theme = Theme.of(context);
    IconData iconData;
    Color iconColor;

    switch (status) {
      case MessageState.delivered:
        iconData = Icons.done_all;
        iconColor = theme.colorScheme.onPrimary.withOpacity(0.7);
        break;
      case MessageState.seen:
        iconData = Icons.done_all;
        iconColor = Colors.blueAccent; // A distinct color for 'seen'
        break;
      case MessageState.sent:
      default:
        iconData = Icons.done;
        iconColor = theme.colorScheme.onPrimary.withOpacity(0.7);
    }
    return Icon(iconData, size: 16.sp, color: iconColor);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isMe ? theme.colorScheme.primary : theme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: isMe ? Radius.circular(16.r) : Radius.circular(0),
            bottomRight: isMe ? Radius.circular(0) : Radius.circular(16.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                ),
              ),
            ),
            if (isMe) ...[
              SizedBox(width: 8.w),
              _buildStatusIcon(context),
            ],
          ],
        ),
      ),
    );
  }
}