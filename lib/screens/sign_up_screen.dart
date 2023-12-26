import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/utils/constants/app_constants.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _usernameController;
  bool isPasswordVisible = true;
  bool isRememberMe = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 CrossFadeState _state = CrossFadeState.showFirst;
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
                      "Sign Up",
                      style: TextStyle(
                        fontFamily: "poppins",
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "Please Sign up to Continue",
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
                      child: AnimatedCrossFade(
                        sizeCurve: Curves.linear,
                        firstCurve: Curves.easeIn,
                        secondCurve: Curves.easeOut,
                        duration: const Duration(milliseconds: 500),
                        crossFadeState: _state,
                        firstChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height:60,
                            ),
                            SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Enter Username",
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
                                    keyboardType: TextInputType.text,
                                    controller: _usernameController,
                                    prefixIcon: Icons.person,
                                    suffixIcon: Icons.arrow_right,
                                    hintText: "Enter a Username",
                                    isSuffixIconVisible: false,
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

                                  var username = _usernameController.text.trim().toString();
                                 if(username.length>5){

                                  if(username.isNotEmpty){

                                 _onTapCrossfadeChange();
                                  }
                                  else{
                                    EasyLoading.showToast("Enter Username",toastPosition: EasyLoadingToastPosition.bottom);
                                  }
                                 }
                                 else{
                                  EasyLoading.showToast("Length must be greater than 5 characters",
                                  
                                  toastPosition: EasyLoadingToastPosition.bottom);
                                 }
                                  
                                },
                                btnTitle: "Continue",
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
                                  "Already have an account?",
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
                                  onTap: _onTapLogin,
                                  child: Text(
                                    "Login",
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
                        secondChild: Column(
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
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              children: [

                                 Expanded(child: CustomButton(width: double.infinity, onPressed: _onTapCrossfadeChange, btnTitle: "Back", bgColor: Theme.of(context).colorScheme.primary.withOpacity(0.8), fgColor: Theme.of(context).colorScheme.onPrimary, height: 50)),
                                 const SizedBox(width: 5,),
                                Expanded(
                                  child: CustomButton(
                                      width: double.infinity,
                                      onPressed: () {
                                        _onTapSignUp();
                                      },
                                      btnTitle: "Sign Up",
                                      bgColor: Theme.of(context).colorScheme.primary,
                                      fgColor: Colors.white,
                                      height: 50),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
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
                                  onTap: _onTapLogin,
                                  child: Text(
                                    "Login",
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onTapCrossfadeChange(){
    setState(() {
      if(_state == CrossFadeState.showFirst){
          _state = CrossFadeState.showSecond;
      }
      else{
        _state = CrossFadeState.showFirst;
      }
    });
  }

  _onTapSignUp() async {
    var email = _emailController.text.trim().toString();
    var password = _passwordController.text.trim().toString();

    if (email.isNotEmpty && password.isNotEmpty) {
      EasyLoading.show(status: "Loading...");
      // var authService = Provider.of<AuthService>(context, listen: false);
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          var user = UserModel(uid: value.user!.uid, email: value.user!.email!,username: _usernameController.text.toString());
          _firestore
              .collection('users')
              .doc(user.uid)
              .set(user.toMap(), SetOptions(merge: true));

          EasyLoading.showToast("Account Created SuccessFully",
              toastPosition: EasyLoadingToastPosition.bottom);
          _setUserPref(value.user?.uid ?? "");
          _navigateToHomePage();
        });
      } catch (e) {
        EasyLoading.showToast(
          e.toString(),
          toastPosition: EasyLoadingToastPosition.bottom,
        );
      }
    } else {
      EasyLoading.showToast("Please Enter The Details",
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  }


  _navigateToHomePage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  _setUserPref(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("username", _usernameController.text.toString());
    prefs.setString("token", uid);
  }

  _onTapLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );

  }
  
}
