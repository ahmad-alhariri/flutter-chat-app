// ==================================================
// PURPOSE: Centralizes all Firestore collection and field names to prevent typos.
// ==================================================
class FirestoreConstants {
  // Collections
  static const String usersCollection = 'users';
  static const String conversationsCollection = 'conversations';
  static const String messagesCollection = 'messages';

  // User Fields
  static const String uid = 'uid';
  static const String username = 'username';
  static const String email = 'email';
  static const String profileImageUrl = 'profileImageUrl';

  // Conversation Fields
  static const String participantIds = 'participantIds';
  static const String lastMessage = 'lastMessage';
  static const String lastMessageTimestamp = 'lastMessageTimestamp';

  // Message Fields
  static const String senderId = 'senderId';
  static const String text = 'text';
  static const String timestamp = 'timestamp';
  static const String status = 'status';
}

class MessageState {
  // Collections
  static const String sent = 'sent';
  static const String delivered = 'delivered';
  static const String seen = 'seen';
}
