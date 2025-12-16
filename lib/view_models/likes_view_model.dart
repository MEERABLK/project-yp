import 'package:projectyp/pages.dart';
import 'package:projectyp/dependencies.dart';


import 'package:cloud_firestore/cloud_firestore.dart';


class LikesViewModel
{
  final CollectionReference likesCollection =
  FirebaseFirestore.instance.collection('Likes');

  Future<LikesModel?> getLikes(String cardId) async {
    final doc = await likesCollection.doc(cardId).get();
    if (doc.exists) {
      return LikesModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return LikesModel(cardId: cardId, userIds: []);
  }

  Future<void> addLike(String cardId, String userId) async {
    final docRef = likesCollection.doc(cardId);
    await docRef.set({
      'cardId': cardId,
      'userIds': FieldValue.arrayUnion([userId])
    }, SetOptions(merge: true));
  }

  Future<void> removeLike(String cardId, String userId) async {
    final docRef = likesCollection.doc(cardId);
    await docRef.set({
      'userIds': FieldValue.arrayRemove([userId])
    }, SetOptions(merge: true));
  }
}
