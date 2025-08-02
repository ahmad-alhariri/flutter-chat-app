import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/core/models/message_model.dart';
import 'package:flutter_chat_app/core/other/BaseViewModel.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';
import 'package:flutter_chat_app/core/services/database_service.dart';

class ChatViewModel extends BaseViewModel {
  final DatabaseService _databaseService;
  final AuthService _authService;
  final String conversationId;

  ChatViewModel(this._databaseService, this._authService, this.conversationId);

  String? get currentUserId => _authService.currentUser?.uid;

  Stream<List<MessageModel>> get messagesStream => _databaseService.getMessagesStream(conversationId);

  Future<void> sendMessage(String text) async {
    final currentUserId = _authService.currentUser?.uid;
    if (currentUserId == null || text.trim().isEmpty) return;

    final message = MessageModel(
      senderId: currentUserId,
      text: text.trim(),
      timestamp: Timestamp.now(),
    );

    await _databaseService.sendMessage(conversationId, message);
  }
}