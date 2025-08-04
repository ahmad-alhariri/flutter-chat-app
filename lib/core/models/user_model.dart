import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/firestore_constants.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String? profileImageUrl;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.profileImageUrl,
  });

  /// Convert a [UserModel] to a json map
  Map<String, dynamic> toMap(){
    return{
      FirestoreConstants.uid:uid,
      FirestoreConstants.username:username,
      FirestoreConstants.email:email,
      FirestoreConstants.profileImageUrl:profileImageUrl
    };
  }

  /// Creates a [UserModel] instance from a Firestore document snapshot.
  factory UserModel.fromMap(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data[FirestoreConstants.uid],
      username: data[FirestoreConstants.username],
      email: data[FirestoreConstants.email],
      profileImageUrl: data[FirestoreConstants.profileImageUrl],
    );
  }
}
