class Article {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String source;
  final String publishedAt;

  Article({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.source,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    String sourceName = '';
    if (json['source'] != null) {
      if (json['source'] is Map) {
        sourceName = json['source']['name'] ?? '';
      } else if (json['source'] is String) {
        sourceName = json['source'];
      }
    }

    return Article(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      urlToImage: json['urlToImage']?.toString() ?? '',
      source: sourceName,
      publishedAt: json['publishedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'source': {'name': source},
      'publishedAt': publishedAt,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article &&
          runtimeType == other.runtimeType &&
          url == other.url;

  @override
  int get hashCode => url.hashCode;
}
