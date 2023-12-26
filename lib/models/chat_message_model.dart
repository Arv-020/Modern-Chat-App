import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String senderId;
  final String senderEmail;
  final String recieverId;
  final String message;
  final Timestamp timeStamp;

  ChatMessageModel(
      {required this.message,
      required this.recieverId,
      required this.senderId,
      required this.senderEmail,
      required this.timeStamp});

  factory ChatMessageModel.fromMap(Map<String,dynamic> data){
    return ChatMessageModel(message: data["message"], recieverId: data["recieverId"], senderId: data["senderId"], senderEmail: data["senderEmail"], timeStamp: data["timeStamp"]);
  }    

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "senderEmail": senderEmail,
      "recieverId": recieverId,
      "message": message,
      "timeStamp": timeStamp,
    };
  }
}
