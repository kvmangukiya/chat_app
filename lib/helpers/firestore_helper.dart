import 'dart:developer';

import 'package:chat_app/modals/chat_modal.dart';
import 'package:chat_app/modals/contact_modal.dart';
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
  String colMsg = "msg";
  String colMsgTime = "msgTime";
  String colSeenTime = "seenTime";
  String colType = "type";
  String colLastMsg = "lastMsg";
  String colLastMsgTime = "lastMsgTime";
  String colLastUnreadMsgCount = "lastUnreadMsgCount";
  String colLastUnreadMsgId = "lastUnreadMsgId";

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

  Future<bool> insertChat(
      {required int senderId,
      required int receiverId,
      required ChatModal chatMsg}) async {
    Map<String, dynamic> chatDataS = {
      colId: chatMsg.id,
      colMsg: chatMsg.msg,
      colMsgTime: chatMsg.msgTime,
      colSeenTime: 0,
      colType: "S",
    };
    Map<String, dynamic> chatDataR = {
      colId: chatMsg.id,
      colMsg: chatMsg.msg,
      colMsgTime: chatMsg.msgTime,
      colSeenTime: 0,
      colType: "R",
    };
    bool sucFlag = false;
    //sender sent message entry
    await firebaseFirestore
        .collection(collection)
        .doc(senderId.toString())
        .collection("contacts")
        .doc(receiverId.toString())
        .collection("chats")
        .doc(chatMsg.id.toString())
        .set(chatDataS)
        .then((value) async {
      //receiver receive message entry
      await firebaseFirestore
          .collection(collection)
          .doc(receiverId.toString())
          .collection("contacts")
          .doc(senderId.toString())
          .collection("chats")
          .doc(chatMsg.id.toString())
          .set(chatDataR)
          .then((value) async {
        ContactModal cUser = await FireStoreHelper.fireStoreHelper
            .contactDetail(senderId: senderId, receiverId: receiverId)
            .then((ud) => ContactModal.fromMap(ud.docs[0].data()));
        if (cUser.lastUnreadMsgCount > 0) {
          cUser.lastUnreadMsgCount += 1;
        } else {
          cUser.lastUnreadMsgCount = 1;
          cUser.lastUnreadMsgId = chatMsg.id;
        }
        //receiver receive unread message count update
        Map<String, dynamic> chatUserData = {
          colLastMsg: chatMsg.msg,
          colLastMsgTime: chatMsg.msgTime,
          colLastUnreadMsgCount: cUser.lastUnreadMsgCount,
          colLastUnreadMsgId: cUser.lastUnreadMsgId,
        };
        await firebaseFirestore
            .collection(collection)
            .doc(receiverId.toString())
            .collection("contacts")
            .doc(senderId.toString())
            .update(chatUserData)
            .then((value) async {
          sucFlag = true;
          log("chat inserted...");
        });
      });
    });
    return sucFlag;
  }

  Future<bool> updateChatContact(
      {required int senderId, required int receiverId}) async {
    bool sucFlag = false;
    //receiver receive unread message count update
    Map<String, dynamic> chatUserData = {
      colLastUnreadMsgCount: 0,
      colLastUnreadMsgId: 0,
    };
    await firebaseFirestore
        .collection(collection)
        .doc(senderId.toString())
        .collection("contacts")
        .doc(receiverId.toString())
        .update(chatUserData)
        .then((value) async {
      sucFlag = true;
      log("unread chat user updated...");
    });
    return sucFlag;
  }

  Future<bool> newChatContact(
      {required int senderId, required int receiverId}) async {
    bool sucFlag = false;
    //sender to receiver chat exist ?
    DocumentSnapshot<Map<String, dynamic>> data = await firebaseFirestore
        .collection(collection)
        .doc(senderId.toString())
        .collection("contacts")
        .doc(receiverId.toString())
        .get();
    if (data.data() == null) {
      //sender to receiver chat creation
      log(receiverId.toString());
      data = await getUserDetailFromID(id: receiverId);
      UserModal userModal = UserModal.fromMap(data.data() as Map);
      Map<String, dynamic> recUserData = {
        colId: receiverId,
        colImagePath: userModal.imagePath,
        colLastMsg: "",
        colLastMsgTime: 0,
        colLastUnreadMsgCount: 0,
        colLastUnreadMsgId: 0,
        colName: userModal.name,
      };
      await firebaseFirestore
          .collection(collection)
          .doc(senderId.toString())
          .collection("contacts")
          .doc(receiverId.toString())
          .set(recUserData)
          .then((value) async {
        sucFlag = true;
      });
    }
    //receiver to sender chat exist ?
    data = await firebaseFirestore
        .collection(collection)
        .doc(receiverId.toString())
        .collection("contacts")
        .doc(senderId.toString())
        .get();
    if (data.data() == null) {
      //receiver to sender chat creation
      data = await getUserDetailFromID(id: senderId);
      UserModal userModal = UserModal.fromMap(data.data() as Map);
      Map<String, dynamic> sendUserData = {
        colId: senderId,
        colImagePath: userModal.imagePath,
        colLastMsg: "",
        colLastMsgTime: 0,
        colLastUnreadMsgCount: 0,
        colLastUnreadMsgId: 0,
        colName: userModal.name,
      };
      await firebaseFirestore
          .collection(collection)
          .doc(receiverId.toString())
          .collection("contacts")
          .doc(senderId.toString())
          .set(sendUserData)
          .then((value) async {
        sucFlag = true;
      });
    }
    return sucFlag;
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

  Stream<QuerySnapshot<Map<String, dynamic>>> getChat(int loginId, int curId) {
    log("loginId: $loginId");
    log("curId: $curId");
    return firebaseFirestore
        .collection(collection)
        .doc(loginId.toString())
        .collection("contacts")
        .doc(curId.toString())
        .collection("chats")
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetailFromID(
      {required int id}) async {
    return await firebaseFirestore
        .collection(collection)
        .doc(id.toString())
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserDetailFromEmail(
      {required String email}) async {
    return await firebaseFirestore
        .collection(collection)
        .where("email", isEqualTo: email)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> contactDetail(
      {required int senderId, required int receiverId}) async {
    return await firebaseFirestore
        .collection(collection)
        .doc(receiverId.toString())
        .collection("contacts")
        .where("id", isEqualTo: senderId)
        .get();
  }

  Future<UserModal?> getGoogleUserDetail(UserModal userModal) async {
    DocumentSnapshot<Map<String, dynamic>> data = await firebaseFirestore
        .collection(collection)
        .doc("{$userModal.id}")
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
