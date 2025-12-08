import 'package:cloud_firestore/cloud_firestore.dart';

class LikesModel {
  String cardId;
  List<String> userIds;

  LikesModel({required this.cardId, required this.userIds});

  Map<String, dynamic> toMap() {
    return {
      'cardId': cardId,
      'userIds': userIds,
    };
  }

  factory LikesModel.fromMap(Map<String, dynamic> map) {
    return LikesModel(
      cardId: map['cardId'] ?? '',
      userIds: List<String>.from(map['userIds'] ?? []),
    );
  }
}
