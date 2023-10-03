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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserModal? lUser;

  Duration get loginTime => const Duration(milliseconds: 500);

  Future<String?> _authUser(LoginData data) async {
    int res = await AuthHelper.authHelper
        .signInWithUserEmail(data.name, data.password);
    switch (res) {
      case 0:
        return "Fail ! didn't signup...";
      case 1:
        lUser = await FireStoreHelper.fireStoreHelper
            .getUserDetailFromEmail(email: data.name)
            .then((ud) => UserModal.fromMap(ud.docs[0].data()));
        return null;
      case 3:
        return "Fail ! you have to sign in via google auth only...";
      default:
        return "Fail ! wrong password...";
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    if (data.name == null || data.password == null) {
      return "Fail !!! please enter proper detail...";
    } else {
      int res = await AuthHelper.authHelper
          .signInWithUserEmail(data.name!, data.password!);
      if (res == 0) {
        int id = DateTime.now().millisecondsSinceEpoch;
        lUser = await FireStoreHelper.fireStoreHelper.insertUsers(
          userModal: UserModal(
              id: id,
              email: data.name!,
              pass: data.password ?? "",
              name: data.name,
              imagePath: "",
              contact: ""),
        );
        log("lUser Signup : ${lUser.toString()}");
        return Future.delayed(loginTime).then((_) {
          return null;
        });
      } else {
        return "Failed !!! already signup...";
      }
    }
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
      theme: LoginTheme(
        pageColorLight: Colors.white,
        pageColorDark: Colors.white,
      ),
      onLogin: _authUser,
      onSignup: _signupUser,
      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: () async {
            log("google sign in callback called");
            lUser = await AuthHelper.authHelper.signInWithGoogle();
            if (lUser != null) {
              debugPrint('start google sign in');
              await Future.delayed(loginTime);
              debugPrint('stop google sign in');
              return null;
            } else {
              return "Fail ! Please try again...";
            }
          },
        ),
      ],
      onSubmitAnimationCompleted: () {
        log("on submit animation called ...");
        Get.offNamed("/home", arguments: lUser);
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
