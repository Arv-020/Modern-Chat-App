import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/getting_started_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              icon:  Icon(Icons.logout,
              
              color: Theme.of(context).colorScheme.onPrimary,))
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
        if(snapshot.connectionState == ConnectionState.none){
          return const Center(child: CircularProgressIndicator(),);
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
        }else{
          return const Center(child: CircularProgressIndicator(),);
        }

       
      },
    );
  }

  Widget listUserItem(DocumentSnapshot document) {
    var user = UserModel.fromMap(document.data() as Map<String, dynamic>);

    if (_auth.currentUser!.email != user.email) {
      return ListTile(
        onTap: (){
          _onTapChat(recieverUserName: user.username,recieverId: user.uid);
        },
        contentPadding: const EdgeInsets.all(10),
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          )
        ),
        title: Text(user.username),
        
      );
    }
    return const SizedBox();
  }
  _onTapChat({required String recieverId,required String recieverUserName }){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(recieverId: recieverId, recieverUserName: recieverUserName)));
  }
}
