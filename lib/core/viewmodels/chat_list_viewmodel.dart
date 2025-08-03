import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/core/constants/routes.dart';
import 'package:flutter_chat_app/core/models/conversation_model.dart';
import 'package:flutter_chat_app/core/models/user_model.dart';
import 'package:flutter_chat_app/core/other/BaseViewModel.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';
import 'package:flutter_chat_app/core/services/database_service.dart';
import 'package:flutter_chat_app/core/services/navigation_service.dart';

import '../enums/enums.dart';

// ==================================================
// PURPOSE: Manages the state for the Chat List Screen.
// ==================================================
class ChatListViewModel extends BaseViewModel {
  final DatabaseService _databaseService;
  final NavigationService _navigationService;
  final User? _user; // The current user is now passed in

  // A cache to store user profiles to avoid repeated Firestore reads.
  final Map<String, UserModel> _userCache = {};
  Map<String, UserModel> get userCache => _userCache;

  StreamSubscription? _conversationsSubscription;

  ChatListViewModel(this._databaseService, this._navigationService, this._user) {
    getConversations();
  }

  Stream<List<ConversationModel>>? conversationsStream;

  void getConversations() {
    if (_user != null) {
      setState(ViewState.Busy);
      _conversationsSubscription?.cancel(); // Cancel previous subscription
      conversationsStream = _databaseService.getConversationsStream(_user!.uid);

      _conversationsSubscription = conversationsStream?.listen(_onConversationsUpdated);

      setState(ViewState.Idle);
    } else {
      conversationsStream = null;
      setState(ViewState.Idle);
    }
  }

  /// Called whenever the conversations stream emits new data.
  Future<void> _onConversationsUpdated(List<ConversationModel> conversations) async {
    // 1. Collect all unique participant IDs that are not already in the cache.
    final currentUserId = _user?.uid;
    final idsToFetch = conversations
        .expand((convo) => convo.participantIds)
        .where((id) => id != currentUserId && !_userCache.containsKey(id))
        .toSet()
        .toList();

    // 2. If there are new IDs to fetch, get them in a single batch.
    if (idsToFetch.isNotEmpty) {
      final newUsers = await _databaseService.getUsersIn(idsToFetch);
      // 3. Update the cache with the newly fetched users.
      for (var user in newUsers) {
        _userCache[user.uid] = user;
      }
      // 4. Notify the UI to rebuild with the new user data.
      notifyListeners();
    }
  }

  void navigateToChat(UserModel otherUser) {
    _navigationService.navigateTo(Routes.chat, arguments: otherUser);
  }

  @override
  void dispose() {
    _conversationsSubscription?.cancel();
    super.dispose();
  }
}