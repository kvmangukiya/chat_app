import 'dart:developer';

import 'package:chat_app/modals/user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper {
  FireStoreHelper._pc();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._pc();
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  String collectionAutoIncrement = "autoIncrement";
  String collection = "users";
  String colId = "id";
  String colEmail = "email";
  String colName = "name";
  String colContact = "contact";
  String colPass = "pass";
  String colImagePath = "imagePath";

  Future<UserModal?> insertUsers({required UserModal userModal}) async {
    Map<String, dynamic> userData = {
      colId: userModal.id,
      colEmail: userModal.email,
      colName: userModal.name,
      colContact: userModal.contact,
      colPass: userModal.pass,
      colImagePath: userModal.imagePath,
    };
    bool sucFlag = false;
    await firebaseFirestore
        .collection(collection)
        .doc(userModal.id.toString())
        .set(userData)
        .then((value) async {
      sucFlag = true;
      log("User data inserted...");
    });
    if (sucFlag) {
      return userModal;
    } else {
      return null;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firebaseFirestore.collection(collection).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllNewChatUser(int id) {
    return firebaseFirestore
        .collection(collection)
        .where("id", isNotEqualTo: id, isGreaterThan: 1)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatUsers(int id) {
    return firebaseFirestore
        .collection(collection)
        .doc(id.toString())
        .collection("contacts")
        .orderBy("lastMsgTime", descending: true)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetailFromID(
      {required int id}) async {
    return await firebaseFirestore.collection(collection).doc("{$id}").get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserDetailFromEmail(
      {required String email}) async {
    return await firebaseFirestore
        .collection(collection)
        .where("email", isEqualTo: email)
        .get();
  }

  Future<UserModal?> getGoogleUserDetail(UserModal userModal) async {
    DocumentSnapshot<Map<String, dynamic>> data = await firebaseFirestore
        .collection(collection)
        .doc("{$userModal.email}")
        .get();
    if (data.data() != null) {
      return UserModal.fromMap(data.data() as Map);
    } else {
      Map<String, dynamic> userData = {
        colId: userModal.id,
        colEmail: userModal.email,
        colName: userModal.name,
        colContact: userModal.contact,
        colPass: userModal.pass,
        colImagePath: userModal.imagePath,
      };
      await firebaseFirestore
          .collection(collection)
          .doc(userModal.id.toString())
          .update(userData);
      return userModal;
    }
  }

  /*//autoincrement logic
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
  }*/

  Future<void> testInsert() async {
    Map<String, dynamic> userData = {"val": 5};
    await firebaseFirestore
        .collection("hichat")
        .doc("1")
        .collection("chat")
        .doc("2")
        .set(userData);
  }
}
