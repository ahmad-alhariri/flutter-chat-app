import 'package:cloud_firestore/cloud_firestore.dart';

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
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
    };
  }

  /// Creates a [MessageModel] instance from a Firestore document.
  factory MessageModel.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      senderId: data['senderId'],
      text: data['text'],
      timestamp: data['timestamp'],
    );
  }
}