import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import '../../model/response_model.dart';
import 'package:logger/logger.dart';

class BookData {
  var logger = Logger();
  // loggerくんがこのコードからprintを駆逐するらしいです。

  final String apiUrl = "https://www.googleapis.com/books/v1/volumes?q=";
  final String searchLimit = "&maxResults=10";
  final String language = "&langRestrict=ja";

  List<BookDataModel>? bookDatas;
  Future<List<BookDataModel>?> bookSearch(String searchWord) async {
    final url = apiUrl + searchWord + language + searchLimit;
    logger.d(url);

    bookDatas = await GetBookApi().fetchData(url);
    return bookDatas;
  }

  Future<List<BookDataModel>?> randomBookSearch() async {
    String randomNumber = (Random().nextInt(10000)).toString();
    final url = ("$apiUrl%$randomNumber%$language$searchLimit&printType=books");
    logger.d(url);

    bookDatas = await GetBookApi().fetchData(url);
    //bookDataView(bookDatas!);
    return bookDatas;
  }

  //bookDataテスト出力用
  bookDataView(List<BookDataModel> bookDatas) {
    for (BookDataModel data in bookDatas) {
      logger.d(data.title);
      logger.d(data.subtitle);
      logger.d(data.authors);
      logger.d(data.publishedDate);
      logger.d(data.description);
      logger.d(data.imageLink);
      logger.d(data.infoLink);
      logger.d(data.isbn10);
      logger.d(data.isbn13);
    }
  }
}

class GetBookApi {
  var logger = Logger();

  Future<List<BookDataModel>> fetchData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      logger.d("正常なレスポンス");
      // レスポンスが成功した場合の処理
      List<BookDataModel> bookDatas =
          createBookDatas(jsonDecode(response.body));
      return bookDatas;
    } else {
      logger.d("異常なレスポンス");
      // レスポンスがエラーだった場合の処理
      List<BookDataModel> errorBooks = [
        BookDataModel(
            id: "エラーID",
            title: "エラーブック",
            subtitle: "レスポンスエラー",
            authors: ["エラーコード:${response.statusCode}"],
            publishedDate: "エラーコード:${response.statusCode}",
            description: "この本はAPIのレスポンスエラーによって生成されます。",
            imageLink: "適当にエラー画像のリンクでも入れておきます？",
            infoLink: "ここのリンクは動作させないようにしておきます？",
            isbn10: "This book is error data.",
            isbn13: "この本はエラーデータです。")
      ];
      return errorBooks;
    }
  }

  List<BookDataModel> createBookDatas(Map<String, dynamic> response) {
    List<BookDataModel> bookDatas = [];
    var json = response['items'];
    for (int i = 0; i < json.length; i++) {
      bookDatas.add(BookDataModel.fromJson(json[i]));
      logger.d("$i回目のデータ返却");
    }
    logger.d("処理完了");

    return bookDatas;
  }
}
