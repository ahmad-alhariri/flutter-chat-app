import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/firestore_constants.dart';

class MessageModel {
  final String senderId;
  final String text;
  final Timestamp timestamp;

  MessageModel({
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  /// Converts this [MessageModel] instance to a JSON map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.senderId: senderId,
      FirestoreConstants.text: text,
      FirestoreConstants.timestamp: timestamp,
    };
  }

  /// Creates a [MessageModel] instance from a Firestore document.
  factory MessageModel.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      senderId: data[FirestoreConstants.senderId],
      text: data[FirestoreConstants.text],
      timestamp: data[FirestoreConstants.timestamp],
    );
  }
}