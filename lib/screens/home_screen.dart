import 'package:chat_app/controllers/user_data_provider.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late Stream<QuerySnapshot> snapshots ; 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
  }

  

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    var users = context.watch<UserDataProvider>().userdData;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
       
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
            height: 280,
            width: double.infinity,
            child: SafeArea(
              child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration:  BoxDecoration(
                           borderRadius: BorderRadius.circular(30),
                           color: Colors.grey.withOpacity(0.3),
                          ),
                          child: const Icon(UniconsLine.search,
                          color: Colors.white,
                          ),
                        ),
                        const CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage("https://cdn.vectorstock.com/i/preview-1x/17/61/male-avatar-profile-picture-vector-10211761.jpg"),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom:30.0),
                    child: SizedBox(
                      height: 80,
                      child: ListView.builder(
                        itemCount: 10,
                        scrollDirection: Axis.horizontal,
                        
                        itemBuilder: (context,index){
                        return  Container(
                          margin:  EdgeInsets.only(left: index==0?30:20,),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: const DecorationImage(image: NetworkImage("https://cdn.vectorstock.com/i/preview-1x/17/61/male-avatar-profile-picture-vector-10211761.jpg")),
                            border: Border.all(
                              width: 5,
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.4)
                            ) 
                          ),
                        
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
          ),
        Expanded(
          child: Container(
            decoration:  BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(40))
            ),
            child: Column(
              children: [
                const Icon(Icons.remove),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context,index){
                      
                    return  ListTile(
                      leading: const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage("https://cdn.vectorstock.com/i/preview-1x/17/61/male-avatar-profile-picture-vector-10211761.jpg"),
                      ),
                      title: Text("Username",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground
                      ),
                      ),
                      
                      subtitle: Text("demo text messages",
                       style: TextStyle(
                        fontFamily: "poppins",
                        color: Theme.of(context).colorScheme.onBackground
                       ),
                      ),
                      
                      trailing: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("1:30pm"),
                          CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.red,
                            child: Center(child: Text("1",
                            style: TextStyle(fontSize:10),)),
                          )
                        ],
                      ),
                    );
                  
                          
                  }),
                ),
              ],
            ),
          ),
        )
        ],
      )
    );
  }

  int getItemCount(){
    return context.read<UserDataProvider>().length;
  }
}
