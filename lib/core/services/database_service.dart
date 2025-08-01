import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

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

}