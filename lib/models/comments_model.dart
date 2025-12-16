import 'package:cloud_firestore/cloud_firestore.dart';

class CommentItem {
  final String userId;
  final String username;
  final String text;
  final DateTime createdAt;

  CommentItem({
    required this.userId,
    required this.username,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CommentItem.fromMap(Map<String, dynamic> map) {
    return CommentItem(
      userId: map['userId'],
      username: map['username'],
      text: map['text'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
