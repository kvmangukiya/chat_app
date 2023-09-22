import 'dart:developer';
import 'package:chat_app/helpers/auth_helper.dart';
import 'package:chat_app/helpers/firestore_helper.dart';
import 'package:chat_app/modals/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

const users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 1250);

  Future<String?> _authUser(LoginData data) async {
    debugPrint('Name: ${data.name}, Password: ${data.password}');

    int res = await AuthHelper.authHelper
        .signInWithUserEmail(int.parse(data.name), data.password);

    if (res == 0) {
      Get.snackbar("Fail !!!", "User doesn't exist...");
    } else {
      if (res > 1) {
        Get.offNamed("/home");
      } else {
        Get.snackbar("Fail !!!", "Password doesn't matched...");
      }
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    await FireStoreHelper.fireStoreHelper.insertUsers(
        userModal: UserModal(
            data.name ?? "", data.password ?? "", data.name, "", "", 0));
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'HI Chat',
      logo: const AssetImage('assets/images/logo.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: () async {
            log("google sign in callback called");
            await AuthHelper.authHelper.signInWithGoogle();
            if (AuthHelper.lUser.email != "") {
              await FireStoreHelper.fireStoreHelper.insertUsers(
                  userModal: UserModal(AuthHelper.lUser.email ?? "", "google",
                      AuthHelper.lUser.name, "", AuthHelper.lUser.contact, 0));
              debugPrint('start google sign in');
              await Future.delayed(loginTime);
              debugPrint('stop google sign in');
              return null;
            }
          },
        ),
      ],
      onSubmitAnimationCompleted: () {
        log("on submit animation called ...");
        Get.offNamed("/home");
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
