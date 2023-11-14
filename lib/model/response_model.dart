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
    logger.d("データ処理");

    String isbn13 = "";
    String isbn10 = "";

    /*
    logger.d("isbn処理");
    if (json['volumeInfo']['industryIdentifiers'][0]['type'] != null) {
      if (json['volumeInfo']['industryIdentifiers'][0]['type'] == "ISBN_13") {
        isbn13 = json['volumeInfo']['industryIdentifiers'][0]['identifier'];
        if (json['volumeInfo']['industryIdentifiers'][1]['type'] != null) {
          isbn10 = json['volumeInfo']['industryIdentifiers'][1]['identifier'];
        }
      }
    }
    */

    logger.d("著者処理");
    List<String> authors = [];
    if (json['volumeInfo']['authors'] != null) {
      for (String name in json['volumeInfo']['authors']) {
        authors.add(name);
      }
    }

    logger.d("残りのデータの処理");
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
