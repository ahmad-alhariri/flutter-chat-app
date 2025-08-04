import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/core/constants/firestore_constants.dart';

class ConversationModel {
  final String id;
  final List<String> participantIds;
  final String lastMessage;
  final Timestamp lastMessageTimestamp;
  final int unreadCount;

  ConversationModel({
    required this.id,
    required this.participantIds,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    this.unreadCount = 0,
  });

  /// Creates a [ConversationModel] instance from a Firestore document.
  factory ConversationModel.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ConversationModel(
      id: doc.id,
      participantIds: List<String>.from(data[FirestoreConstants.participantIds]),
      lastMessage: data[FirestoreConstants.lastMessage] ?? '',
      lastMessageTimestamp: data[FirestoreConstants.lastMessageTimestamp] ?? Timestamp.now(),
      unreadCount: data['unreadCount'] ?? 0,
    );
  }
}