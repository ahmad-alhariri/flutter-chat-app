import 'package:flutter_chat_app/core/models/conversation_model.dart';
import 'package:flutter_chat_app/core/other/BaseViewModel.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';
import 'package:flutter_chat_app/core/services/database_service.dart';

import '../../../core/enums/enums.dart';

class ChatsViewModel extends BaseViewModel {
  final DatabaseService _databaseService;
  final AuthService _authService;

  ChatsViewModel(this._databaseService, this._authService) {
    getConversations();
  }

  Stream<List<ConversationModel>>? conversationsStream;

  void getConversations() {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      setState(ViewState.Busy);
      conversationsStream = _databaseService.getConversationsStream(userId);
      setState(ViewState.Idle);
    } else {
      setState(ViewState.Error, message: "User not logged in.");
    }
  }
}