import 'package:logger/logger.dart';

class BookDataModel {
  final String id; //googleBooksのID ★主キー
  final String title; //タイトル
  final String subtitle; //サブタイトル
  final List<String> authors; //著者
  final String publishedDate; //発刊日 (モノによっては年のみや年月までといったデータもあり)
  final String description; //紹介文
  final String imageLink; //画像のリンク
  final String infoLink; //googleBookの紹介リンク
  final String isbn10; //10桁のISBN
  final String isbn13; //13桁のISBN

  BookDataModel(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.authors,
      required this.publishedDate,
      required this.description,
      required this.imageLink,
      required this.infoLink,
      required this.isbn10,
      required this.isbn13});

  factory BookDataModel.fromJson(Map<String, dynamic> json) {
    var logger = Logger();

    String isbn10 = "";
    String isbn13 = "";

    try {
      for (var data in json['volumeInfo']['industryIdentifiers']) {
        switch (data['type']) {
          case "ISBN_10":
            isbn10 = data['identifier'];
            break;
          case "ISBN_13":
            isbn13 = data['identifier'];
            break;
          default:
            break;
        }
      }
    } catch (e) {
      logger.d("識別コード無し");
    }

    List<String> authors = [];
    if (json['volumeInfo']['authors'] != null) {
      for (String name in json['volumeInfo']['authors']) {
        authors.add(name);
      }
    }

    var model = BookDataModel(
        id: json['id'] ?? "",
        title: json['volumeInfo']['title'] ?? "",
        subtitle: json['volumeInfo']['subtitle'] ?? "",
        authors: authors,
        publishedDate: json['volumeInfo']['publishedDate'] ?? "",
        description: json['volumeInfo']['description'] ?? "",
        imageLink: json['volumeInfo']['imageLinks']['thumbnail'] ?? "",
        infoLink: json['volumeInfo']['previewLink'] ?? "",
        isbn10: isbn10,
        isbn13: isbn13);

    return model;
  }
}
