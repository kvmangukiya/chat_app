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

  Future<void> signOutWithGoogle() async {
    await google.signOut();
  }
}
