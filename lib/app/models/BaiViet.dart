class Article {
  final int id;
  final String title;
  final DateTime datePosted;
  final String author;
  final List<ArticleImage> images;
  final List<ArticleContent> contents;

  Article({
    required this.id,
    required this.title,
    required this.datePosted,
    required this.author,
    required this.images,
    required this.contents,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    // Xử lý danh sách hình ảnh
    List<ArticleImage> imagesList = [];
    if (json.containsKey('anhBaiViets') && json['anhBaiViets'] != null) {
      var list = json['anhBaiViets']['\$values'] as List? ?? [];
      imagesList = list.map((i) => ArticleImage.fromJson(i)).toList();
    }

    // Xử lý danh sách nội dung
    List<ArticleContent> contentsList = [];
    if (json.containsKey('noiDungBaiViets') && json['noiDungBaiViets'] != null) {
      var list = json['noiDungBaiViets']['\$values'] as List? ?? [];
      contentsList = list.map((i) => ArticleContent.fromJson(i)).toList();
    }

    return Article(
      id: json['iD_BaiViet'] ?? 0,
      title: json['tieuDe'] ?? 'Không có tiêu đề',
      datePosted: json['ngayDang'] != null
          ? DateTime.parse(json['ngayDang'])
          : DateTime.now(),
      author: json['tacGia'] ?? 'Không rõ tác giả',
      images: imagesList,
      contents: contentsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "TieuDe": title,
      "NgayDang": datePosted.toUtc().toIso8601String(), // Matches "Z" format
      "TacGia": author,
      "AnhBaiViets": images.map((img) => img.toJson()).toList(),
      "NoiDungBaiViets": contents.map((content) => content.toJson()).toList(),
    };
  }
}

class ArticleImage {
  final int id;
  final int articleId;
  final String url;
  final String description;

  ArticleImage({
    required this.id,
    required this.articleId,
    required this.url,
    required this.description,
  });

  factory ArticleImage.fromJson(Map<String, dynamic> json) {
    return ArticleImage(
      id: json['iD_Anh'] ?? 0,
      articleId: json['iD_BaiViet'] ?? 0,
      url: json['duongDan'] ?? '',
      description: json['moTa'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "DuongDan": url,
      "MoTa": description,
    };
  }
}

class ArticleContent {
  final int id;
  final int articleId;
  final int order;
  final String content;

  ArticleContent({
    required this.id,
    required this.articleId,
    required this.order,
    required this.content,
  });

  factory ArticleContent.fromJson(Map<String, dynamic> json) {
    return ArticleContent(
      id: json['iD_NoiDung'] ?? 0,
      articleId: json['iD_BaiViet'] ?? 0,
      order: json['thuTu'] ?? 0,
      content: json['noiDung'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ThuTu": order,
      "NoiDung": content,
    };
  }
}