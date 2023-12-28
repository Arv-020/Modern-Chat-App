
import 'dart:developer' as console show log;
import 'package:chat_app/models/chat_message_model.dart';
import 'package:chat_app/models/notification_model.dart';
import 'package:chat_app/services/api_services.dart';
import 'package:chat_app/services/chat_services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
   const ChatScreen({super.key, required this.recieverId, required this.recieverUserName, required this.token});
final String recieverId;
final String token;
final String recieverUserName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
final FirebaseAuth _auth = FirebaseAuth.instance;
late TextEditingController _messageController ;


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messageController = TextEditingController();
    

  }

  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _messageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading:  GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios,
          color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        title: Text(widget.recieverUserName,
        style: TextStyle(
          fontFamily: "poppins",
          color: Theme.of(context).colorScheme.onPrimary,
        ),),

      
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover
            ,image: AssetImage("assets/images/chat-bg-img.jpeg"))
        ),
        child: chatScreenBody(context),
      ),
     
    );
  }

  Widget chatScreenBody(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          
          child: chatMessageWidget(context)),
           chatInputWidget()
      ],
    );
  }

 Widget chatMessageWidget(BuildContext context){
   var chatService = context.read<ChatService>().getMessages(widget.recieverId);
    
   return StreamBuilder<QuerySnapshot>(stream:chatService, builder: (context, snapshot) {
     if(snapshot.connectionState == ConnectionState.waiting){
      return const Center(
        child: CircularProgressIndicator(),
      );

      
     }

     if(snapshot.hasData){
      return ListView(
        reverse: true,
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
         
        dragStartBehavior: DragStartBehavior.down,
        shrinkWrap: true,
        
        // shrinkWrap: true,
        // reverse: trueSS,
      
        children: snapshot.data!.docs.map((doc) => GestureDetector(
          onTap:(){
            console.log(doc["senderId"]);
            console.log(doc["recieverId"]);
            console.log(_auth.currentUser!.uid);
            if(doc["senderId"]==_auth.currentUser!.uid){
              context.read<ChatService>().deleteMessage(doc["recieverId"]);
            }
          },
          child: chatMessageItemWidget(doc))).toList()
      );
     }

     return const SizedBox();
   },);

 }

 Widget chatMessageItemWidget(DocumentSnapshot document){
   var chatMessage =  ChatMessageModel.fromMap(document.data() as Map<String,dynamic>);
  bool isSendedByMe = chatMessage.senderId == _auth.currentUser!.uid;
   return Container(
    
    alignment: isSendedByMe? Alignment.bottomRight : Alignment.bottomLeft  ,
    margin: const EdgeInsets.only(bottom: 11,top: 11),
    
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        
        Container(
   
          decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
     borderRadius: BorderRadius.horizontal(left: Radius.circular(isSendedByMe?10:0),right: Radius.circular(isSendedByMe?0:10) )
          ),
          padding: const EdgeInsets.fromLTRB(30, 11, 20, 11),
          child: Text(chatMessage.message,
          
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 16,
          ),))],
    ),
   );

 }

 Widget chatInputWidget() {

  return  Container(
    decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.background,
    borderRadius: BorderRadius.circular(26)

    ),
    padding: const EdgeInsets.all(5),
    margin:const EdgeInsets.all(15),
    child: Row(
      
      children: [
        const SizedBox(width: 11,),
         Icon(Icons.emoji_emotions,
        color: Theme.of(context).colorScheme.primary,),
        Expanded(
          child: TextField(
            controller: _messageController,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              )
            ),
          ),
        ),
    
        InkWell(
          onTap: (){
            _onTapSend();
          },
           child: Icon(Icons.send,
                   color: Theme.of(context).colorScheme.primary,),
         ),
        const SizedBox(width: 11,),
      ],
    ),
  );
 }
 
  void _onTapSend() async{

    
    var message = _messageController.text.trim().toString();
    if(message.isNotEmpty){
    context.read<ChatService>().sendMessage(widget.recieverId, message).then((value) async{


    _messageController.clear();
    FocusManager.instance.primaryFocus?.unfocus();

    var notificationResult = await ApiService.sendMessage(notification: NotificationModel(token: widget.token, data: NotificationData(recieverId: widget.recieverId, recieverUserName: widget.recieverUserName,token: widget.token), notification: NotificationBody(body:message)));
    
    if(notificationResult==0){
      EasyLoading.showToast("Failed to send Notification",toastPosition: EasyLoadingToastPosition.bottom);
    }
    });
    


     
    }
    

  }
}