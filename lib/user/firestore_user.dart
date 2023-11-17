import 'package:bookrack/user/book_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUser {
  final db = FirebaseFirestore.instance;
  final String uid;
  late final BookCollection likedBooks = BookCollection(
    uid: uid,
    collectionName: 'likedBooks',
  );

  late final BookCollection bookmarkedBooks = BookCollection(
    uid: uid,
    collectionName: 'bookmarkedBooks',
  );

  FirestoreUser({required this.uid});

  Future<bool> exists() async {
    final doc = await db.collection('users').doc(uid).get();
    
    return doc.exists;
  }

  Future<void> delete() async {
    await db.collection('users').doc(uid).delete();
  }
}