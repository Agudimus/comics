class DetailKomik {
  final String title;
  final String rating;
  final String status;
  final String thumbnail;
  final String author;
  final String description;
  final List<Map<String, String>> genre;
  final List<Map<String, String>> chapter;

  DetailKomik({
    required this.title,
    required this.rating,
    required this.status,
    required this.thumbnail,
    required this.author,
    required this.description,
    required this.genre,
    required this.chapter,
  });
}
