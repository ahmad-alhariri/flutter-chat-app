import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/core/models/conversation_model.dart';
import 'package:flutter_chat_app/core/models/message_model.dart';

import '../models/user_model.dart';

class DatabaseService{

  final FirebaseFirestore _fireStore;

  DatabaseService(this._fireStore);

  Future<void> createUser(UserModel user) async{
    try{
      await _fireStore.collection('users').doc(user.uid).set(user.toMap());
    }catch (e){
      // Handle potential errors, e.g., by logging them.
      log("Error creating user in Firestore: $e");
      rethrow;
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await _fireStore.collection('users').doc(uid).get();
      if(doc.exists) {
        return UserModel.fromMap(doc);
      }
      return null;
    } catch (e) {
      print("Error getting user: $e");
      return null;
    }
  }

  /// Fetches a real-time stream of all users except the one with the given UID.
  Stream<List<UserModel>> getUsersStream(String currentUserId) {
    return _fireStore.collection('users').where('uid', isNotEqualTo: currentUserId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromMap(doc)).toList();
    });
  }

  /// Fetches a real-time stream of conversations for a given user.
  Stream<List<ConversationModel>> getConversationsStream(String userId) {
    return _fireStore
        .collection('conversations')
        .where('participantIds', arrayContains: userId)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ConversationModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<String> createOrGetConversation(String currentUserId, String otherUserId) async {
    List<String> sortedIds = [currentUserId, otherUserId]..sort();
    String conversationId = sortedIds.join('_');

    final conversationDoc = _fireStore.collection('conversations').doc(conversationId);
    final docSnapshot = await conversationDoc.get();

    if (!docSnapshot.exists) {
      await conversationDoc.set({
        'participantIds': sortedIds,
        'lastMessage': '',
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
      });
    }
    return conversationId;
  }

  Stream<List<MessageModel>> getMessagesStream(String conversationId) {
    return _fireStore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => MessageModel.fromFirestore(doc)).toList());
  }

  Future<void> sendMessage(String conversationId, MessageModel message) async {
    await _fireStore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add(message.toJson());

    await _fireStore.collection('conversations').doc(conversationId).update({
      'lastMessage': message.text,
      'lastMessageTimestamp': message.timestamp,
    });
  }

}