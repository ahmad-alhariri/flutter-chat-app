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
  List<ConversationModel> conversations = [];

  ChatListViewModel(this._databaseService, this._navigationService, this._user) {
    _listenToConversations();
  }

  void _listenToConversations() {
    setState(ViewState.Busy);
    _conversationsSubscription?.cancel();
    if (_user != null) {
      _conversationsSubscription = _databaseService
          .getConversationsStream(_user!.uid)
          .listen((updatedConversations) {
        conversations = updatedConversations;
        _fetchUsersForConversations(conversations);
        setState(ViewState.Idle);
      });
    } else {
      conversations = [];
      setState(ViewState.Idle);
    }
  }

  Future<void> _fetchUsersForConversations(List<ConversationModel> conversations) async {
    final currentUserId = _user?.uid;
    final idsToFetch = conversations
        .expand((convo) => convo.participantIds)
        .where((id) => id != currentUserId && !_userCache.containsKey(id))
        .toSet()
        .toList();

    if (idsToFetch.isNotEmpty) {
      final newUsers = await _databaseService.getUsersIn(idsToFetch);
      for (var user in newUsers) {
        _userCache[user.uid] = user;
      }
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

