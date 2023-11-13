import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import '../../model/response_model.dart';
import 'package:logger/logger.dart';

class BookData {
  var logger = Logger();
  // loggerくんがこのコードからprintを駆逐するらしいです。

  final String apiUrl = "https://www.googleapis.com/books/v1/volumes?q=";
  final String searchLimit = "&maxResults=1";
  final String language = "&langRestrict=ja";

  BookDataModel? bookData;
  Future<BookDataModel?> bookSearch(String searchWord) async {
    final url = apiUrl + searchWord + language + searchLimit;

    bookData = await GetBookApi().fetchData(url);
    return bookData;
  }

  Future<BookDataModel?> randomBookSearch() async {
    String randomNumber = (Random().nextInt(10000)).toString();
    final url = ("$apiUrl%$randomNumber%$language$searchLimit&printType=books");
    logger.d(url);

    bookData = await GetBookApi().fetchData(url);
    logger.d("データ処理完了");
    bookDataView(bookData!);
    return bookData;
  }

  //bookDataテスト出力用
  bookDataView(BookDataModel bookData) {
    logger.d(bookData.title);
    logger.d(bookData.subtitle);
    logger.d(bookData.authors);
    logger.d(bookData.publishedDate);
    logger.d(bookData.description);
    logger.d(bookData.imageLink);
    logger.d(bookData.infoLink);
    logger.d(bookData.isbn10);
    logger.d(bookData.isbn13);
  }
}

class GetBookApi {
  var logger = Logger();

  Future<BookDataModel> fetchData(String url) async {
    final response = await http.get(Uri.parse(url));
    logger.d(response.body);

    if (response.statusCode == 200) {
      logger.d("正常なレスポンス");
      // レスポンスが成功した場合の処理
      BookDataModel bookData =
          BookDataModel.fromJson(jsonDecode(response.body));
      return bookData;
    } else {
      logger.d("異常なレスポンス");
      // レスポンスがエラーだった場合の処理
      BookDataModel errorBook = BookDataModel(
          id: "エラーID",
          title: "エラーブック",
          subtitle: "レスポンスエラー",
          authors: ["エラーコード:${response.statusCode}"],
          publishedDate: "エラーコード:${response.statusCode}",
          description: "この本はAPIのレスポンスエラーによって生成されます。",
          imageLink: "適当にエラー画像のリンクでも入れておきます？",
          infoLink: "ここのリンクは動作させないようにしておきます？",
          isbn10: "This book is error data.",
          isbn13: "この本はエラーデータです。");
      return errorBook;
    }
  }
}
