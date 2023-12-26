import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/utils/constants/app_constants.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _usernameController;
  bool isPasswordVisible = true;
  bool isRememberMe = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
      body: Center(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset("assets/animations/chat-animation.json"),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      AppConstants.appName,
                      style: TextStyle(
                          fontFamily: "poppins",
                          fontSize: 20,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Log In",
                      style: TextStyle(
                        fontFamily: "poppins",
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "Please Sign in to Continue",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(40))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 15, 25, 25),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Enter Email",
                                  style: TextStyle(
                                      fontFamily: "poppins",
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                CustomTextField(
                                  onSufficIconPressed: () {},
                                  obscureText: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  prefixIcon: Icons.mail,
                                  suffixIcon: Icons.arrow_right,
                                  hintText: "Enter Your Email",
                                  isSuffixIconVisible: false,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Enter Password",
                                  style: TextStyle(
                                      fontFamily: "poppins",
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                CustomTextField(
                                    onSufficIconPressed: () {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                      });
                                    },
                                    obscureText: isPasswordVisible,
                                    controller: _passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    prefixIcon: Icons.lock,
                                    suffixIcon: isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    hintText: "Enter Your Password",
                                    isSuffixIconVisible: true),
                                const SizedBox(
                                  height: 11,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isRememberMe = !isRememberMe;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        isRememberMe
                                            ? Icons.check_box_outlined
                                            : Icons.check_box_outline_blank,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.5),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Remember me",
                                        style: TextStyle(
                                            fontFamily: "poppins",
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "Forgot Password",
                                        style: TextStyle(
                                            fontFamily: "poppins",
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground
                                                .withOpacity(0.5)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          CustomButton(
                              width: double.infinity,
                              onPressed: () {
                                _onTapLogin();
                              },
                              btnTitle: "Log In",
                              bgColor: Theme.of(context).colorScheme.primary,
                              fgColor: Colors.white,
                              height: 50),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: _onTapSignUp,
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontFamily: "poppins",
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onTapLogin() async {
    var email = _emailController.text.trim().toString();
    var password = _passwordController.text.trim().toString();

    SharedPreferences prefs =await SharedPreferences.getInstance();
    var userName = prefs.getString("username")?? "";

    if (email.isNotEmpty && password.isNotEmpty) {
      // var authService = context.read<AuthService>();
      EasyLoading.show(status: "Loading...");
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
          var user = UserModel(uid: value.user!.uid, email: value.user!.email!,username: userName);
          _firestore.collection("users").doc(user.uid).set(
                user.toMap(),
              );
          EasyLoading.showToast("Logged-In SuccessFully",
              toastPosition: EasyLoadingToastPosition.bottom);
          _setUserPrefs(value.user?.uid ?? "");
          _navigateToHomePage();
        });
      } on Exception catch (e) {
        EasyLoading.showToast(
          "$e",
          toastPosition: EasyLoadingToastPosition.bottom,
        );
      }
    } else {
      EasyLoading.showToast(
        "Please Enter Details",
        toastPosition: EasyLoadingToastPosition.bottom,
      );
    }
  }

  _setUserPrefs(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
      "token",
      uid,
    );
  }

  _navigateToHomePage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  _onTapSignUp() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }
}
