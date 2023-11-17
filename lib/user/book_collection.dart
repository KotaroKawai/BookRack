import 'package:bookrack/user/firestore_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookCollection {
  final _db = FirebaseFirestore.instance;
  final String uid;
  late final String collectionName;
  late final books = _db.collection('users').doc(uid).collection(collectionName); 

  BookCollection(
    {
      required this.uid,
      required this.collectionName,
    }
  );

  /// 小レクソンの本を削除する
  Future<void> removeBook(String id) async {
    return books.doc(id).delete();
  }

  /// コレクションに本を追加する
  Future<void> addBook(FirestoreBook data) async {
    if (data.id == '') {
      throw Exception('idは空です');
    }

    return books.doc(data.id).set({
      'title': data.title,
      'authors': data.authors,
      'imageUrl': data.imageUrl,
    });
  }

  /// コレクションから本を取得する
  Future<List<FirestoreBook>> getBooks(int limit) async {
    return books.limit(limit).get() as Future<List<FirestoreBook>>;
  }

  /// コレクションに本が含まれているかどうかを返す
  Future<bool> contains(String id) async {
    final doc = await books.doc(id).get();
    return doc.exists;
  }
}