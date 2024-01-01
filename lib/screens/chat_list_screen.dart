import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/getting_started_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shimmer/shimmer.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  void _signOutUser() async {
    // var authService = context.read<AuthService>();

    // authService.signOut();
    try {
      await _auth.signOut().then((value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const GettingStartedScreen()));
      });
    } catch (e) {
      EasyLoading.showToast(
        "$e",
        toastPosition: EasyLoadingToastPosition.bottom,
      );
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Chat-Buddy",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _signOutUser();
              },
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.onPrimary,
              ))
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: userListWidget(),
    );
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

  Widget listUserItem(DocumentSnapshot document) {
    var user = UserModel.fromMap(document.data() as Map<String, dynamic>);

    if (_auth.currentUser!.email != user.email) {
      return ListTile(
        onTap: () {
          _onTapChat(
            recieverUserName: user.username,
            recieverId: user.uid,
            token: user.token,
          );
        },
        leading: CachedNetworkImage(
          imageUrl: user.profileImage.isEmpty
              ? "https://cdn.vectorstock.com/i/preview-1x/17/61/male-avatar-profile-picture-vector-10211761.jpg"
              : user.profileImage,
          height: 60,
          placeholder: (context, url) {
            return const Shimmer(
              gradient: LinearGradient(colors: [Colors.red, Colors.green]),
              child: CircleAvatar(
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
}
