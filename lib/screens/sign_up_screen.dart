import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/user_model.dart';
import 'dart:developer' as console show log;
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/navigation_bar_screen.dart';
import 'package:chat_app/utils/constants/app_constants.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unicons/unicons.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  bool isPasswordVisible = true;
  bool isRememberMe = false;
  bool isImageLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CrossFadeState _continueState = CrossFadeState.showFirst;
  CrossFadeState _signUpMethodState = CrossFadeState.showFirst;
  CrossFadeState _otpMethodState = CrossFadeState.showFirst;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
  }
  String otp = "";
  String imageUrl = "";
  double mHeight = 0;
  double mWidth = 0;
  @override
  Widget build(BuildContext context) {

    var mH = MediaQuery.sizeOf(context).height;
    var mW = MediaQuery.sizeOf(context).width;
    mHeight = mH;
    mWidth = mW;

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
                        crossFadeState: _continueState,
                        firstChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: GestureDetector(
                                      onTap: _onTapProfile,
                                      child: Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          imageUrl.isEmpty
                                              ? CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage: const AssetImage(
                                                      "assets/images/default-profile-image.jpeg"),
                                                  child: isImageLoading
                                                      ? const CircularProgressIndicator()
                                                      : const SizedBox(),
                                                )
                                              : CachedNetworkImage(
                                                  imageBuilder:
                                                      (context, imageProvider) {
                                                    return CircleAvatar(
                                                      radius: 50,
                                                      backgroundImage:
                                                          imageProvider,
                                                    );
                                                  },
                                                  imageUrl: imageUrl,
                                                  placeholder: (context, url) {
                                                    return Shimmer(
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colors.grey,
                                                            Colors
                                                                .grey.shade100,
                                                          ]),
                                                      child: CircleAvatar(
                                                        radius: 50,
                                                        backgroundColor: Colors
                                                            .grey
                                                            .withOpacity(0.4),
                                                        child: const SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  height: 100,
                                                ),
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor:
                                                Colors.grey.withOpacity(0.6),
                                            child: const Icon(Icons.brush),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
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
                                    isPrefixVisible: true,
                                    maxLines: 1,
                                    isEnabled: true,
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
                            SizedBox(
                              height: mH * .05,
                            ),
                            CustomButton(
                                width: double.infinity,
                                onPressed: () {
                                  var username = _usernameController.text
                                      .trim()
                                      .toString();
                                  if (username.length > 5) {
                                    if (username.isNotEmpty) {
                                      _onTapCrossfadeChange();
                                    } else {
                                      EasyLoading.showToast("Enter Username",
                                          toastPosition:
                                              EasyLoadingToastPosition.bottom);
                                    }
                                  } else {
                                    EasyLoading.showToast(
                                        "Length must be greater than 5 characters",
                                        toastPosition:
                                            EasyLoadingToastPosition.bottom);
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
                        secondChild: AnimatedCrossFade(
                          sizeCurve: Curves.linear,
                          firstCurve: Curves.easeIn,
                          secondCurve: Curves.easeOut,
                          duration: const Duration(milliseconds: 500),
                          crossFadeState: _signUpMethodState,
                          firstChild: Column(
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
                                      isPrefixVisible: true,
                                      maxLines: 1,
                                      isEnabled: true,
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
                                        isPrefixVisible: true,
                                        maxLines: 1,
                                        isEnabled: true,
                                        onSufficIconPressed: () {
                                          setState(() {
                                            isPasswordVisible =
                                                !isPasswordVisible;
                                          });
                                        },
                                        obscureText: isPasswordVisible,
                                        controller: _passwordController,
                                        keyboardType:
                                            TextInputType.visiblePassword,
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
                              SizedBox(
                                height: mH * .05,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  authenticationMethodWidget(
                                    onPressed: () {
                                      _signUpMethodState =
                                          CrossFadeState.showSecond;
                                      setState(() {});
                                    },
                                    icon: UniconsLine.phone,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  authenticationMethodWidget(
                                    onPressed: _onTapGoogleSignIn,
                                    icon: UniconsLine.google,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 11,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: CustomButton(
                                          width: double.infinity,
                                          onPressed: _onTapCrossfadeChange,
                                          btnTitle: "Back",
                                          bgColor: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.8),
                                          fgColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          height: 50)),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: CustomButton(
                                        width: double.infinity,
                                        onPressed: () {
                                          _onTapSignUp();
                                        },
                                        btnTitle: "Sign Up",
                                        bgColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          secondChild: phoneAuthenticationWidget(),
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

  Widget authenticationMethodWidget(
      {required VoidCallback onPressed, required IconData icon}) {
    return GestureDetector(
      onTap: onPressed,
      child: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        child: Icon(icon),
      ),
    );
  }

  Widget phoneAuthenticationWidget() {
    return AnimatedCrossFade(
        sizeCurve: Curves.linear,
        firstCurve: Curves.easeIn,
        secondCurve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
        crossFadeState: _otpMethodState,
        firstChild: Column(
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
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter Phone Number",
                    style: TextStyle(
                        fontFamily: "poppins",
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextField(
                    isPrefixVisible: true,
                    maxLines: 1,
                    isEnabled: true,
                    onSufficIconPressed: () {},
                    obscureText: false,
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    prefixIcon: Icons.mail,
                    suffixIcon: Icons.arrow_right,
                    hintText: "Enter Your Phone Number",
                    isSuffixIconVisible: false,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: mHeight * .02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                authenticationMethodWidget(
                  onPressed: () {
                    _signUpMethodState = CrossFadeState.showFirst;
                    setState(() {});
                  },
                  icon: Icons.mail,
                ),
                const SizedBox(
                  width: 10,
                ),
                authenticationMethodWidget(
                  onPressed: _onTapGoogleSignIn,
                  icon: UniconsLine.google,
                )
              ],
            ),
            const SizedBox(
              height: 11,
            ),
            Row(
              children: [
                Expanded(
                    child: CustomButton(
                        width: double.infinity,
                        onPressed: () {
                          _signUpMethodState = CrossFadeState.showFirst;
                          setState(() {});
                        },
                        btnTitle: "Back",
                        bgColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.8),
                        fgColor: Theme.of(context).colorScheme.onPrimary,
                        height: 50)),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: CustomButton(
                      width: double.infinity,
                      onPressed: () {
                        var phoneNumber =
                            _phoneController.text.trim().toString();
                        if (phoneNumber.isNotEmpty) {
                          if (phoneNumber.length == 10) {
                            //otp work
                            _otpMethodState = CrossFadeState.showSecond;
                            setState(() {});
                          } else {
                            EasyLoading.showToast(
                              "Length must be 10 digits longer",
                              toastPosition: EasyLoadingToastPosition.bottom,
                            );
                          }
                        } else {
                          EasyLoading.showToast(
                            "Please Enter the Phone Number",
                            toastPosition: EasyLoadingToastPosition.bottom,
                          );
                        }
                      },
                      btnTitle: "Continue",
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
                    color: Theme.of(context).colorScheme.onBackground,
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
                      color: Theme.of(context).colorScheme.primary,
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
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter Otp",
                    style: TextStyle(
                        fontFamily: "poppins",
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Pinput(
                    length: 6,
                    onChanged: (value) {
                      otp = value;
                      // console.log(otp);
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: mHeight * .05,
            ),
            Row(
              children: [
                Expanded(
                    child: CustomButton(
                        width: double.infinity,
                        onPressed: () {
                          _otpMethodState = CrossFadeState.showFirst;
                          setState(() {});
                        },
                        btnTitle: "Back",
                        bgColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.8),
                        fgColor: Theme.of(context).colorScheme.onPrimary,
                        height: 50)),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: CustomButton(
                      width: double.infinity,
                      onPressed: () {
                        var phoneNumber =
                            _phoneController.text.trim().toString();
                        if (otp.isNotEmpty) {
                          if (otp.length == 6) {
                            console.log("hahahahaha");
                          } else {
                            EasyLoading.showToast(
                              "Length must be 6 digits longer",
                              toastPosition: EasyLoadingToastPosition.bottom,
                            );
                          }
                        } else {
                          EasyLoading.showToast(
                            "Please Enter the Otp",
                            toastPosition: EasyLoadingToastPosition.bottom,
                          );
                        }
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
                    color: Theme.of(context).colorScheme.onBackground,
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
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }

  _onTapGoogleSignIn() async {
    GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
    var token = await FirebaseMessaging.instance.getToken();
    try {
      await _auth.signInWithProvider(googleAuthProvider).then((value) {
        var user = UserModel(
            bio: "",
            profileImage: imageUrl,
            token: token!,
            username: _usernameController.text.trim().toString(),
            uid: value.user!.uid,
            email: value.user!.email!);

        _firestore.collection("users").doc(user.uid).set(
              user.toMap(),
              SetOptions(merge: true),
            );
        EasyLoading.showToast("Account Created SuccessFully",
            toastPosition: EasyLoadingToastPosition.bottom);
        _setUserPref(token);
        _navigateToHomePage();
      });
    } catch (e) {
      EasyLoading.showToast(
        e.toString(),
        toastPosition: EasyLoadingToastPosition.bottom,
      );
    }
  }

  _generateOtp() {}

  _onTapProfile() {


    _customModalBottomSheet();
  }

  void _customModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 100,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    "Choose the Option",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _customMenuItem(
                        icon: Icons.camera,
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(10)),
                        onPressed: () {
                          isImageLoading = true;
                          setState(() {});
                          _pickAndUploadImage(ImageSource.camera);
                        }),
                    const SizedBox(
                      width: 1,
                    ),
                    _customMenuItem(
                        icon: Icons.image,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10)),
                        onPressed: () {
                          isImageLoading = true;
                          setState(() {});
                          _pickAndUploadImage(ImageSource.gallery);
                        }),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void _pickAndUploadImage(ImageSource imageSource) async {
    ImagePicker imagePicker = ImagePicker();
    console.log("We are almost there");
    XFile? file = await imagePicker.pickImage(source: imageSource);
    if (file == null) return;

    if (!mounted) return;
    Navigator.pop(context);
    
     
    Reference firebaseStorage = FirebaseStorage.instance.ref();
    Reference firebaseImageDir = firebaseStorage.child("Images");
    Reference firebaseImageName = firebaseImageDir.child(file.name);

    try {
      await firebaseImageName.putFile(File(file.path));

      imageUrl = await firebaseImageName.getDownloadURL();
      setState(() {
        isImageLoading = false;
      });
     

      console.log(imageUrl);
    } catch (error) {
     
      EasyLoading.showToast("$error",
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  }

  Widget _customMenuItem(
      {required VoidCallback onPressed,
      required IconData icon,
      required BorderRadius borderRadius}) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: 50,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          child: Icon(icon),
        ),
      ),
    );
  }

  _onTapCrossfadeChange() {
    setState(() {
      if (_continueState == CrossFadeState.showFirst) {
        _continueState = CrossFadeState.showSecond;
      } else {
        _continueState = CrossFadeState.showFirst;
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
          var token = await FirebaseMessaging.instance.getToken();
          if (imageUrl.isEmpty) {
            imageUrl =
                "https://cdn.vectorstock.com/i/preview-1x/17/61/male-avatar-profile-picture-vector-10211761.jpg";
          }
          var user = UserModel(
              bio: "",
              profileImage: imageUrl,
              token: token!,
              uid: value.user!.uid,
              email: value.user!.email!,
              username: _usernameController.text.trim.toString());
          _firestore
              .collection('users')
              .doc(user.uid)
              .set(user.toMap(), SetOptions(merge: true));

          EasyLoading.showToast("Account Created SuccessFully",
              toastPosition: EasyLoadingToastPosition.bottom);
          _setUserPref(token);
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
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const NavigationBarScreen()));
  }

  _setUserPref(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("username", _usernameController.text.toString());
    prefs.setString("profileImage", imageUrl);
    prefs.setString("token", token);
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
