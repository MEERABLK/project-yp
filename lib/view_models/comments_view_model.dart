import 'package:projectyp/pages.dart';
import 'package:projectyp/dependencies.dart';
import 'package:projectyp/pages.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


class CommentsViewModel {
  final CollectionReference commentsCollection =
  FirebaseFirestore.instance.collection('Comments');

  Future<List<CommentItem>> getComments(String cardId) async {
    final doc = await commentsCollection.doc(cardId).get();
    if (!doc.exists) return [];

    final data = doc.data() as Map<String, dynamic>;
    final List items = data['items'] ?? [];

    return items.map((e) => CommentItem.fromMap(e)).toList();
  }

  Future<void> addComment(
      String cardId,
      CommentItem comment,
      ) async {
    await commentsCollection.doc(cardId).set({
      'items': FieldValue.arrayUnion([comment.toMap()])
    }, SetOptions(merge: true));
  }
}
