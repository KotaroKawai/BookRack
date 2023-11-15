import 'package:bookrack/components/home/book_panel.dart';
import 'package:bookrack/components/home/book_panel_props.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../components/api/bookdata_get.dart';

class Content {
  final String title; //著者
  final String text; //あらすじ
  final String? imageUrl; // Can be null for now, you might add images later
  final String? url; // Can be null for now, you might add URLs later

  Content({required this.title, required this.text, this.imageUrl, this.url});
}

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        scrollDirection: Axis.vertical,
        children: [
          BookPanel(
            content: BookPanelProps(
              title: '吾輩は猫である',
              text: '中学の英語教師、珍野苦沙弥先生の家に何とか入り込んで、無事飼われることになった猫が、苦沙弥先生の家族や、家にやってくる友人を観察するお話です。　主人の家には、美学者の迷亭、理学者で先生の教え子の寒月、哲学者の独仙、詩人の東風など、風変わりな文化人たちがやってきては、役にたたないおしゃべりばかりをしているなあ、と猫は思っています。＜日本の名作　小学上級から　すべての漢字にふりがなつき＞＊電子版にイラストは入っていません。',
              authors: "夏目漱石",
              imageUrl: 'https://m.media-amazon.com/images/I/81tO1-C43zL._AC_UF1000,1000_QL80_.jpg',
              url: 'https://m.media-amazon.com/images/I/81tO1-C43zL._AC_UF1000,1000_QL80_.jpg',
            ),
          ),
          BookPanel(
            content: BookPanelProps(
              title: '1984年',
              text: '『1984年』または『1984』は、1949年に刊行したイギリスの作家ジョージ・オーウェルのディストピアSF小説。全体主義国家によって分割統治された近未来世界の恐怖を描いている。欧米での評価が高く、思想・文学・音楽など様々な分野に今なお多大な影響を与えている近代文学傑作品の一つである。',
              authors: "ジョージ・オーウェル",
              imageUrl: 'https://cdn.kobo.com/book-images/a5312ed2-bc80-4f4c-972b-c24dc5990bd5/1200/1200/False/george-orwell-1984-4.jpg',
              url: 'https://cdn.kobo.com/book-images/a5312ed2-bc80-4f4c-972b-c24dc5990bd5/1200/1200/False/george-orwell-1984-4.jpg',
            ),
          ),
          BookPanel(
            content: BookPanelProps(
              title: '吾輩は猫である',
              text: '中学の英語教師、珍野苦沙弥先生の家に何とか入り込んで、無事飼われることになった猫が、苦沙弥先生の家族や、家にやってくる友人を観察するお話です。　主人の家には、美学者の迷亭、理学者で先生の教え子の寒月、哲学者の独仙、詩人の東風など、風変わりな文化人たちがやってきては、役にたたないおしゃべりばかりをしているなあ、と猫は思っています。＜日本の名作　小学上級から　すべての漢字にふりがなつき＞＊電子版にイラストは入っていません。',
              authors: "夏目漱石",
              imageUrl: 'https://m.media-amazon.com/images/I/81tO1-C43zL._AC_UF1000,1000_QL80_.jpg',
              url: 'https://m.media-amazon.com/images/I/81tO1-C43zL._AC_UF1000,1000_QL80_.jpg',
            ),
          ),
          ],
      )
    );
  }
}
