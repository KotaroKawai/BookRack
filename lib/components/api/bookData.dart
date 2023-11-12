import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import '../../model/responseModel.dart';

class BookData {
  var res;
  Future<void> bookSearch(String searchWord) async {
    res = await GetBookApi().fetchData(searchWord);
    print(res);
  }

  Future<void> randomBookSearch() async {
    String randomNumber = (Random().nextInt(10000)).toString();
    print("乱数$randomNumber");
    res = await GetBookApi().fetchData(randomNumber);
    print(res.title);
    print(res.subtitle);
    print(res.authors);
    print(res.publishedDate);
    print(res.description);
    print(res.imageLink);
    print(res.infoLink);
  }
}

class GetBookApi {
  final String apiUrl = "https://www.googleapis.com/books/v1/volumes?q=";
  final String searchLimit = "&maxResults=1";
  final String language = "&langRestrict=ja";

  Future<Object> fetchData(String searchWord) async {
    final url = apiUrl + searchWord + language + searchLimit;
    print(url);

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // レスポンスが成功した場合の処理
      var bookData = BookDataModel.fromJson(jsonDecode(response.body));
      return bookData;
    } else {
      // レスポンスがエラーだった場合の処理
      print('レスポンスエラー・エラーコード: ${response.statusCode}');
      return "エラー";
    }
  }
}
