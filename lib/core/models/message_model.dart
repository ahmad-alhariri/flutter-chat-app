import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/firestore_constants.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final Timestamp timestamp;
  final String status;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.status
  });

  /// Converts this [MessageModel] instance to a JSON map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.senderId: senderId,
      FirestoreConstants.text: text,
      FirestoreConstants.timestamp: timestamp,
      FirestoreConstants.status: status
    };
  }

  /// Creates a [MessageModel] instance from a Firestore document.
  factory MessageModel.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      senderId: data[FirestoreConstants.senderId],
      text: data[FirestoreConstants.text],
      timestamp: data[FirestoreConstants.timestamp],
      status: data[FirestoreConstants.status] ?? MessageState.sent
    );
  }
}