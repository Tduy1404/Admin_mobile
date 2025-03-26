import 'package:flutter/material.dart';
import 'package:project1/app/models/BaiViet.dart';
import 'package:project1/app/services/api_baiviet.dart';

class EditArticleScreen extends StatefulWidget {
  final Article article;
  const EditArticleScreen({Key? key, required this.article}) : super(key: key);

  @override
  _EditArticleScreenState createState() => _EditArticleScreenState();
}

class _EditArticleScreenState extends State<EditArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  final ApiService _apiService = ApiService();

  late List<TextEditingController> _contentControllers;
  late List<TextEditingController> _imageUrlControllers;
  late List<TextEditingController> _imageDescControllers;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.article.title);
    _authorController = TextEditingController(text: widget.article.author);

    _contentControllers = widget.article.contents
        .map((content) => TextEditingController(text: content.content))
        .toList();

    _imageUrlControllers = widget.article.images
        .map((image) => TextEditingController(text: image.url))
        .toList();

    _imageDescControllers = widget.article.images
        .map((image) => TextEditingController(text: image.description))
        .toList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    for (var controller in _contentControllers) {
      controller.dispose();
    }
    for (var controller in _imageUrlControllers) {
      controller.dispose();
    }
    for (var controller in _imageDescControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    List<ArticleContent> updatedContents = [];
    for (int i = 0; i < _contentControllers.length; i++) {
      updatedContents.add(ArticleContent(
        id: widget.article.contents[i].id,
        articleId: widget.article.id,
        order: i + 1,
        content: _contentControllers[i].text,
      ));
    }

    List<ArticleImage> updatedImages = [];
    for (int i = 0; i < _imageUrlControllers.length; i++) {
      updatedImages.add(ArticleImage(
        id: widget.article.images[i].id,
        articleId: widget.article.id,
        url: _imageUrlControllers[i].text,
        description: _imageDescControllers[i].text,
      ));
    }

    Article updatedArticle = Article(
      id: widget.article.id,
      title: _titleController.text,
      datePosted: widget.article.datePosted,
      author: _authorController.text,
      images: updatedImages,
      contents: updatedContents,
    );

    bool success = await _apiService.updateArticle(updatedArticle);

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cập nhật bài viết!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chỉnh sửa bài viết")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: "Tiêu đề"),
                  validator: (value) =>
                  value!.isEmpty ? "Vui lòng nhập tiêu đề" : null,
                ),
                TextFormField(
                  controller: _authorController,
                  decoration: InputDecoration(labelText: "Tác giả"),
                  validator: (value) =>
                  value!.isEmpty ? "Vui lòng nhập tác giả" : null,
                ),
                SizedBox(height: 20),
                Text("Nội dung bài viết", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _contentControllers.length,
                  itemBuilder: (context, index) {
                    return TextFormField(
                      controller: _contentControllers[index],
                      decoration: InputDecoration(labelText: "Nội dung ${index + 1}"),
                      maxLines: 3,
                      validator: (value) =>
                      value!.isEmpty ? "Vui lòng nhập nội dung" : null,
                    );
                  },
                ),
                SizedBox(height: 20),
                Text("Hình ảnh bài viết", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _imageUrlControllers.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        TextFormField(
                          controller: _imageUrlControllers[index],
                          decoration: InputDecoration(labelText: "Đường dẫn ảnh ${index + 1}"),
                        ),
                        TextFormField(
                          controller: _imageDescControllers[index],
                          decoration: InputDecoration(labelText: "Mô tả ảnh ${index + 1}"),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: Text("Lưu thay đổi"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
