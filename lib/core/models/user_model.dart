import 'package:cloud_firestore/cloud_firestore.dart';

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
      'uid':uid,
      'username':username,
      'email':email,
      'profileImageUrl':profileImageUrl
    };
  }

  /// Creates a [UserModel] instance from a Firestore document snapshot.
  factory UserModel.fromMap(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'],
      username: data['username'],
      email: data['email'],
      profileImageUrl: data['profileImageUrl'],
    );
  }
}
