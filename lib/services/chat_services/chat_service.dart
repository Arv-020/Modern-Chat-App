import 'package:chat_app/models/chat_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



// send Message Function
  Future<void> sendMessage(String recieverId,String message) async{
   //information of current user
   final String senderId = _auth.currentUser!.uid;
   final String senderEmail = _auth.currentUser!.email!;

   // chat instance
   var chatInstance = ChatMessageModel(message: message, recieverId: recieverId, senderId: senderId, senderEmail: senderEmail, timeStamp: Timestamp.now());



//creating chat room id 
   List<String> dns = [recieverId,senderId];
   dns.sort();
   String chatRoomId = dns.join("_");


 await _firestore.collection("chat_room").doc(chatRoomId).collection("messages").add(chatInstance.toMap());

  }

Future<void> deleteMessage(String recieverId) async{
  
 final String senderId = _auth.currentUser!.uid;


  List<String> dns = [recieverId,senderId];

  dns.sort();
  final String chatRoomId = dns.join("_");

  await  _firestore.collection("chat_room").doc(chatRoomId).collection("messages").doc(senderId).delete().then((value){
    print("Deleted SuccessFully");
  },onError: (e){
 print("$e");
  });
}

  Stream<QuerySnapshot<Map<String,dynamic>>> getMessages(String recieverId) {
    final String senderId = _auth.currentUser!.uid;
    // generating chat room id
    List<String> dns = [recieverId,senderId];
    dns.sort();
    final String chatRoomId = dns.join("_");
     
   // returning snapshots of doc
    return _firestore.collection("chat_room").doc(chatRoomId).collection("messages").orderBy("timeStamp",descending: true).snapshots();
    
    
  }

   
}