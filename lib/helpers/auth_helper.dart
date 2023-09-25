import 'dart:developer';

import 'package:chat_app/helpers/firestore_helper.dart';
import 'package:chat_app/modals/user_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper {
  static GoogleSignIn google = GoogleSignIn();

  AuthHelper._pc();

  static final AuthHelper authHelper = AuthHelper._pc();

  Future<UserModal?> signInWithGoogle() async {
    UserModal? lUser;
    final GoogleSignInAccount? googleUser = await google.signIn();
    if (googleUser == null) {
      return null;
    } else {
      // logic for insertion of google account login
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      //////////////
      //logic for google account checking and creation
      int resp = await signInWithUserEmail(googleUser.email, "");
      if (resp == 0) {
        int id = DateTime.now().millisecondsSinceEpoch;
        lUser = await FireStoreHelper.fireStoreHelper.insertUsers(
            userModal: UserModal(
                id: id,
                email: googleUser.email,
                pass: "",
                name: googleUser.displayName,
                imagePath: googleUser.photoUrl,
                contact: ""));
      } else {
        await FireStoreHelper.fireStoreHelper
            .getUserDetailFromEmail(email: googleUser.email)
            .then((userModal) {
          lUser = UserModal.fromMap(userModal.docs[0].data());
        });
      }
      return lUser;
    }
  }

  Future<int> signInWithUserEmail(String email, String pass) async {
    int retValue = 0;
    await FireStoreHelper.fireStoreHelper
        .getUserDetailFromEmail(email: email)
        .then((userModal) {
      UserModal um = UserModal.fromMap(userModal.docs[0].data());
      if (um.pass.isNotEmpty) {
        // google auth user signing at here is wrong
        if (um.pass.length == pass.length) {
          if (um.pass == pass) {
            retValue = 1;
          } else {
            retValue = 2;
          }
        } else {
          retValue = 2;
        }
      } else {
        retValue = 3;
      }
    }).onError((error, stackTrace) {
      retValue = 0;
    });
    return retValue;
  }

  Future<void> signOutWithGoogle() async {
    await google.signOut();
  }
}
