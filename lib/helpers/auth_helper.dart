import 'package:chat_app/helpers/firestore_helper.dart';
import 'package:chat_app/modals/user_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper {
  static GoogleSignIn google = GoogleSignIn();
  static UserModal lUser = UserModal("", "", "", "", "", 0);

  AuthHelper._pc();

  static final AuthHelper authHelper = AuthHelper._pc();

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await google.signIn();
    lUser = UserModal(
      googleUser!.email,
      "",
      googleUser.displayName,
      googleUser.photoUrl,
      "",
      0,
    );

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<int> signInWithUserEmail(int id, String pass) async {
    UserModal userModal =
        await FireStoreHelper.fireStoreHelper.getUserDetail(id);
    if (userModal.id > 0) {
      if (userModal.pass.length == pass.length) {
        if (userModal.pass == pass) {
          return 1;
        } else {
          return 2;
        }
      } else {
        return 2;
      }
    } else {
      return 0;
    }
  }

  Future<void> signOutWithGoogle() async {
    await google.signOut();
  }
}
