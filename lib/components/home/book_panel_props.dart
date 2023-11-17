class BookPanelProps {
  final String id;
  final String title; //著者
  final String text; //あらすじ
  final String authors;
  final String? imageUrl; // Can be null for now, you might add images later
  final String? url; // Can be null for now, you might add URLs later

  BookPanelProps({required this.id, required this.title, required this.text, required this.authors, this.imageUrl, this.url});
}