import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/core/constants/firestore_constants.dart';
import 'package:flutter_chat_app/core/models/message_model.dart';
import 'package:flutter_chat_app/core/other/BaseViewModel.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';
import 'package:flutter_chat_app/core/services/database_service.dart';

// ==================================================
// PURPOSE: Manages the state and logic for a single chat conversation.
// ==================================================
class ChatViewModel extends BaseViewModel {
  final DatabaseService _databaseService;
  final AuthService _authService;
  final String conversationId;

  StreamSubscription? _messagesSubscription;
  List<MessageModel> messages = [];

  ChatViewModel(this._databaseService, this._authService, this.conversationId) {
    _listenToMessages();
  }

  String? get currentUserId => _authService.currentUser?.uid;

  void _listenToMessages() {
    _messagesSubscription = _databaseService
        .getMessagesStream(conversationId)
        .listen((updatedMessages) {
      messages = updatedMessages;
      // When messages are received, mark them as 'delivered'.
      _markMessagesAsDelivered();
      notifyListeners();
    });
  }

  Future<void> sendMessage(String text) async {
    if (currentUserId == null || text.trim().isEmpty) return;

    final message = MessageModel(
      id: '', // Firestore will generate this
      senderId: currentUserId!,
      text: text.trim(),
      timestamp: Timestamp.now(),
      status: MessageState.sent,
    );

    await _databaseService.sendMessage(conversationId, message);
  }

  /// Marks received messages with status 'sent' as 'delivered'.
  void _markMessagesAsDelivered() {
    if (currentUserId == null) return;
    final messageIdsToUpdate = messages
        .where((msg) => msg.senderId != currentUserId && msg.status == MessageState.sent)
        .map((msg) => msg.id)
        .toList();

    if (messageIdsToUpdate.isNotEmpty) {
      _databaseService.updateMessageStatus(
        conversationId: conversationId,
        messageIds: messageIdsToUpdate,
        status: MessageState.delivered,
      );
    }
  }

  /// Marks all unread messages from the other user as 'seen'.
  void markMessagesAsSeen() {
    if (currentUserId == null) return;
    final messageIdsToUpdate = messages
        .where((msg) => msg.senderId != currentUserId && msg.status != MessageState.seen)
        .map((msg) => msg.id)
        .toList();

    if (messageIdsToUpdate.isNotEmpty) {
      _databaseService.updateMessageStatus(
        conversationId: conversationId,
        messageIds: messageIdsToUpdate,
        status: MessageState.seen,
      );
    }
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }
}