import 'package:bookrack/user/liked_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final db = FirebaseFirestore.instance;
  final String uid;
  late final likedBooks = db.collection('users').doc(uid).collection('likedBooks');

  User({required this.uid});

  /// ユーザーのお気に入り本を削除する
  Future<void> removeLikedBook(String id) async {
    return likedBooks.doc(id).delete();
  }

  /// ユーザーのお気に入り本を追加する
  Future<void> addLikedBook(LikedBook data) async {
    if (data.id == '') {
      throw Exception('idは空です');
    }

    return likedBooks.doc(data.id).set({
      'title': data.title,
      'authors': data.authors,
      'imageUrl': data.imageUrl,
    });
  }

  /// ユーザーのお気に入り本を取得する
  Future<List<LikedBook>> getLikedBooks(int limit) async {
    return likedBooks.limit(limit).get() as Future<List<LikedBook>>;
  }

  /// ユーザーが本をお気に入りにしているかどうかを返す
  Future<bool> isLikedBook(String id) async {
    final doc = await likedBooks.doc(id).get();
    return doc.exists;
  }
}