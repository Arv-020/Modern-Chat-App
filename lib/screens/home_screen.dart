import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/controllers/user_data_provider.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/models/user_status_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/status_screen.dart';
import 'package:chat_app/services/status_services/status_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unicons/unicons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<QuerySnapshot> snapshots;
  UserModel? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  String imageUrl = "";
  bool isLoading = false;

  getUserDetails() async {
    isLoading = true;
    setState(() {});
    var data = await _firebaseFirestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .get();

    user = UserModel.fromMap(data.data() as Map<String, dynamic>);
    setState(() {
      isLoading = false;
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    
 
    return Scaffold(
        extendBody: true,

        
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
              // color: Colors.red,
            
              width: double.infinity,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                   
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              child: const Icon(
                                UniconsLine.search,
                                color: Colors.white,
                              ),
                            ),
                            isLoading
                                ? const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 25,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: user!.profileImage,
                                    placeholder: (context, url) {
                                      return Shimmer(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.grey,
                                            Colors.grey.shade100
                                          ],
                                        ),
                                        child: const CircleAvatar(
                                          radius: 25,
                                        ),
                                      );
                                    },
                                    imageBuilder: (context, imageProvider) {
                                      return CircleAvatar(
                                        radius: 25,
                                        backgroundImage: imageProvider,
                                      );
                                    },
                                  )
                          ],
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SizedBox(
                          height: 80,
                          child: StreamBuilder<QuerySnapshot>(
                              stream: _firebaseFirestore
                                  .collection("status")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var statusList = snapshot.data!.docs
                                      .where((element) =>
                                          element["uid"] !=
                                          _auth.currentUser!.uid)
                                      .toList();
                                  return _statusListWidget(statusList);
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                          
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,

              child: Container(

                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    // color: Colors.red,

                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(40))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.remove),
                    Expanded(
                      child: userListWidget(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }


  Widget _statusListWidget(List statusList) {
    return ListView.builder(
        itemCount: statusList.length + 1,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          UserStatusModel? statusData;
          if (index != statusList.length) {
            statusData = UserStatusModel.fromMap(
                statusList[index].data() as Map<String, dynamic>);
          }
          return GestureDetector(
            onTap: () {
              if (index != statusList.length) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            StatusScreen(imageUrl: statusData!.statusImage)));
              } else {
                _customModalBottomSheet();
              }
            },
            child: index == statusList.length
                ? Container(
                    margin: EdgeInsets.only(left: statusList.isEmpty ? 30 : 20),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: user == null
                              ? "https://cdn.vectorstock.com/i/preview-1x/17/61/male-avatar-profile-picture-vector-10211761.jpg"
                              : user!.profileImage,
                          placeholder: (context, url) {
                            return Shimmer(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.grey,
                                  Colors.grey.shade100,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(
                                    width: 5,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withOpacity(0.5),
                                  ),
                                ),
                              ),
                            );
                          },
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: imageProvider),
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  width: 5,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.5),
                                ),
                              ),
                            );
                          },
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            child: Icon(Icons.add),
                          ),
                        )
                      ],
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl: statusData!.statusImage,
                    placeholder: (context, url) {
                      return Container(
                        margin: EdgeInsets.only(left: index == 0 ? 30 : 20),
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            width: 5,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.5),
                          ),
                        ),
                      );
                    },
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        margin: EdgeInsets.only(left: index == 0 ? 30 : 20),
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover, image: imageProvider),
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            width: 5,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.5),
                          ),
                        ),
                      );
                    },
                  ),
          );
        });
  }

  void _addStatus(UserStatusModel userStatus) async {
    await context.read<StatusService>().addStatus(userStatus);
  }

  Widget userListWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          return ListView(
            shrinkWrap: true,
            // physics: const BouncingScrollPhysics(),
            children:
                snapshot.data!.docs.map((doc) => listUserItem(doc)).toList(),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
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

      _addStatus(
        UserStatusModel(
            statusTime: Timestamp.now(),
            uid: _auth.currentUser!.uid,
            statusImage: imageUrl,
            userName: user!.username),
      );
      setState(() {});
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

  Widget listUserItem(DocumentSnapshot document) {
    var user = UserModel.fromMap(document.data() as Map<String, dynamic>);
    var profileUrl = user.profileImage.isEmpty
        ? "https://cdn.vectorstock.com/i/preview-1x/17/61/male-avatar-profile-picture-vector-10211761.jpg"
        : user.profileImage;
    if (_auth.currentUser!.email != user.email) {
      return ListTile(
        onTap: () {
          _onTapChat(
            recieverUserName: user.username,
            recieverId: user.uid,
            token: user.token,
          );
        },
        leading: GestureDetector(
          onLongPress: () {
            _customImageDialog(profileUrl, user.username);
          },
          child: CachedNetworkImage(
            imageUrl: profileUrl,
            height: 60,
            placeholder: (context, url) {
              return Shimmer(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey,
                    Colors.grey.shade100,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                ),
              );
            },
            maxHeightDiskCache: 60,
            maxWidthDiskCache: 60,
            imageBuilder: (context, imageProvider) {
              return CircleAvatar(
                radius: 30,
                backgroundImage: imageProvider,
              );
            },
          ),
        ),
        contentPadding: const EdgeInsets.all(10),
        subtitle: Text(
          "demo text messages",
          style: TextStyle(
              fontFamily: "poppins",
              color: Theme.of(context).colorScheme.onBackground),
        ),
        trailing: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("1:30pm"),
            CircleAvatar(
              radius: 8,
              backgroundColor: Colors.red,
              child: Center(
                  child: Text(
                "1",
                style: TextStyle(fontSize: 10),
              )),
            )
          ],
        ),
        title: Text(user.username),
      );
    }
    return const SizedBox();
  }

  _customImageDialog(String imageUrl, String name) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) {
              return Shimmer(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.grey.shade100,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  child: Container(
                    height: 400,
                    width: double.infinity,
                    color: Colors.grey,
                  ));
            },
            maxHeightDiskCache: 60,
            maxWidthDiskCache: 60,
            imageBuilder: (context, imageProvider) {
              return Container(
                height: 400,
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: imageProvider,
                  ),
                ),
              );
            },
          ),
          title: Container(
            height: 20,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              name,
              style: const TextStyle(
                  fontFamily: "poppins",
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }

  _onTapChat(
      {required String recieverId,
      required String recieverUserName,
      required String token}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatScreen(
                token: token,
                recieverId: recieverId,
                recieverUserName: recieverUserName)));
  }

  int getItemCount() {
    return context.read<UserDataProvider>().length;
  }
}
