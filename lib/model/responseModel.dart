class BookDataModel {
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
      {required this.title,
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

    var model = BookDataModel(
        title: data['volumeInfo']['title'] != null
            ? data['volumeInfo']['title']
            : "",
        subtitle: data['volumeInfo']['subtitle'] != null
            ? data['volumeInfo']['subtitle']
            : "",
        authors: data['volumeInfo']['authors'] != null
            ? List<String>.from(data['volumeInfo']['authors'])
            : <String>[],
        publishedDate: data['volumeInfo']['publishedDate'] != null
            ? data['volumeInfo']['publishedDate']
            : "",
        description: data['volumeInfo']['description'] != null
            ? data['volumeInfo']['description']
            : "",
        imageLink: data['volumeInfo']['imageLinks']['thumbnail'] != null
            ? data['volumeInfo']['imageLinks']['thumbnail']
            : "",
        infoLink: data['volumeInfo']['previewLink'] != null
            ? data['volumeInfo']['previewLink']
            : "",
        isbn10:
            data['volumeInfo']['industryIdentifiers'][0]['identifier'] != null
                ? data['volumeInfo']['industryIdentifiers'][0]['identifier']
                : "",
        isbn13:
            data['volumeInfo']['industryIdentifiers'][1]['identifier'] != null
                ? data['volumeInfo']['industryIdentifiers'][1]['identifier']
                : "");

    return model;
  }
}
