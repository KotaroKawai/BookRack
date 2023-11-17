import 'package:bookrack/user/book_collection.dart';
import 'package:bookrack/user/firestore_book.dart';
import 'package:bookrack/user/firestore_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.useFirestoreEmulator("localhost", 9098);
  });

  group("Collection modification", () {
    test("Adds book", () async {
      BookCollection collection = BookCollection(uid: "test", collectionName: "cats");    

      expect(collection.count(), completion(0));

      await collection.addBook(FirestoreBook(title: "potato", authors: "jimmy", imageUrl: "sdfsd", id: "TEST"));

      expect(collection.count(), completion(1));
      expect(collection.contains("TEST"), completion(true));

      await FirestoreUser(uid: "test").delete();
    });

    test("Removes book", () async {
      BookCollection collection = BookCollection(uid: "wow", collectionName: "cats");

      await collection.addBook(FirestoreBook(title: "potato", authors: "jimmy", imageUrl: "sdfsd", id: "TEST"));

      expect(collection.count(), completion(1));
      expect(collection.contains("TEST"), completion(true));

      await collection.removeBook("TEST");

      expect(collection.count(), completion(0));
      expect(collection.contains("TEST"), completion(false));
    });

    test("Gets all books", () async {
      BookCollection collection = BookCollection(uid: "yeet", collectionName: "potatoes");

      await collection.addBook(
        FirestoreBook(title: "potato", authors: "jimmy", imageUrl: "sdfsd", id: "TEST")
      );

      await collection.addBook(
        FirestoreBook(title: "potato", authors: "jimmy", imageUrl: "sdfsd", id: "TEST2")
      );
      
      expect(collection.count(), 2);
      expect(collection.contains("TEST"), completion(true));
      expect(collection.contains("TEST2"), completion(true));

      List<FirestoreBook> books = await collection.getBooks(2);

      expect(books.length, 2);
    });
  });

  
}