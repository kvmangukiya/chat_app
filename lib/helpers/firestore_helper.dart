import 'dart:developer';

import 'package:chat_app/modals/autoinc_modal.dart';
import 'package:chat_app/modals/user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreHelper {
  FireStoreHelper._pc();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._pc();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  String collectionAutoIncrement = "autoIncrement";
  String collection = "users";
  String colId = "id";
  String colEmail = "email";
  String colName = "name";
  String colContact = "contact";
  String colPass = "pass";
  String colImagePath = "imagePath";

  Future<void> insertUsers({required UserModal userModal}) async {
    int newUserId = await getUsersId();

    Map<String, dynamic> userData = {
      colId: newUserId,
      colEmail: userModal.email,
      colName: userModal.name,
      colContact: userModal.contact,
      colPass: userModal.pass,
      colImagePath: userModal.imagePath,
    };

    await firebaseFirestore
        .collection(collection)
        .doc(newUserId.toString())
        .set(userData)
        .then((value) async {
      await insertUsersId(newUserId + 1);
      log("User data inserted...");
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firebaseFirestore.collection(collection).snapshots();
  }

  Future<UserModal> getUserDetail(int id) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await firebaseFirestore.collection(collection).doc("{$id}").get();
    if (data.data() != null) {
      UserModal userModal = UserModal.fromMap(data.data() as Map);
      return userModal;
    } else {
      return UserModal("", "", "", "", "", 0);
    }
  }

  //autoincrement logic
  Future<int> getUsersId() async {
    DocumentSnapshot<Map<String, dynamic>> data = await firebaseFirestore
        .collection(collectionAutoIncrement)
        .doc(collection)
        .get();
    AutoIncrement userAI = AutoIncrement.fromMap(data.data() as Map);
    return userAI.val;
  }

  //autoincrement logic
  Future<void> insertUsersId(int id) async {
    Map<String, dynamic> userData = {"val": id};
    await firebaseFirestore
        .collection(collectionAutoIncrement)
        .doc(collection)
        .set(userData);
  }
}
