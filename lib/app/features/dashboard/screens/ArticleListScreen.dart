import 'package:flutter/material.dart';
import 'package:project1/app/models/BaiViet.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;
  const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sắp xếp nội dung và ảnh xen kẽ
    List<Widget> buildContentWithImages() {
      List<Widget> widgets = [];
      final contents = article.contents;
      final images = article.images;

      // Sắp xếp nội dung theo thứ tự
      contents.sort((a, b) => a.order.compareTo(b.order));

      // Tính toán vị trí để xen kẽ ảnh
      int contentCount = contents.length; // 4 đoạn nội dung
      int imageCount = images.length; // 3 ảnh
      double step = contentCount / (imageCount + 1); // Khoảng cách giữa các ảnh

      int contentIndex = 0;
      int imageIndex = 0;

      // Thêm tiêu đề "Nội dung" trước
      // widgets.add(const Text(
      //   // 'Nội dung:',
      //   // style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      // ));
      widgets.add(const SizedBox(height: 8));

      // Xen kẽ nội dung và ảnh
      for (int i = 0; i < contentCount + imageCount; i++) {
        // Kiểm tra xem có nên chèn ảnh tại vị trí này không
        if (imageIndex < imageCount && i == ((imageIndex + 1) * step).floor()) {
          final image = images[imageIndex];
          final String localImagePath = 'lib/app/images/${image.url}';
          widgets.add(Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    localImagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text(
                        'Không thể tải hình ảnh',
                        style: TextStyle(color: Colors.red),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  image.description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ));
          imageIndex++;
        } else if (contentIndex < contentCount) {
          // Thêm nội dung
          final content = contents[contentIndex];
          widgets.add(Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              ' ${content.content}',
              style: const TextStyle(fontSize: 16),
            ),
          ));
          contentIndex++;
        }
      }

      return widgets;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết bài viết"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề bài viết
            Text(
              article.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Tác giả và ngày đăng
            Text(
              'Tác giả: ${article.author} - Ngày: ${article.datePosted.toString().substring(0, 10)}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            // Hiển thị nội dung và ảnh xen kẽ
            ...buildContentWithImages(),
          ],
        ),
      ),
    );
  }
}