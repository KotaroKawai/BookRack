class BookDataModel {
  final String id; //googleBooksのID
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
//required this.icon
  factory BookDataModel.fromJson(Map<String, dynamic> json) {
    var data = json['items'][0];

    String isbn10 = "";
    String isbn13 = "";

    if (data['volumeInfo']['industryIdentifiers'][0]['type'] == "ISBN_10") {
      isbn10 = data['volumeInfo']['industryIdentifiers'][0]['identifier'];
      isbn13 = data['volumeInfo']['industryIdentifiers'][1]['identifier'];
    }

    List<String> authors = [];
    for (String name in data['volumeInfo']['authors']) {
      authors.add(name);
    }

    var model = BookDataModel(
        id: data['id'] ?? "",
        title: data['volumeInfo']['title'] ?? "",
        subtitle: data['volumeInfo']['subtitle'] ?? "",
        authors: authors,
        publishedDate: data['volumeInfo']['publishedDate'] ?? "",
        description: data['volumeInfo']['description'] ?? "",
        imageLink: data['volumeInfo']['imageLinks']['thumbnail'] ?? "",
        infoLink: data['volumeInfo']['previewLink'] ?? "",
        isbn10: isbn10,
        isbn13: isbn13);

    return model;
  }
}
