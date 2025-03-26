// import 'package:flutter/material.dart';
// import 'package:project1/app/features/dashboard/widgets/dashboard_appbar.dart';
// import 'package:project1/app/features/dashboard/widgets/dashboard_drawer.dart';
// import 'package:project1/app/features/dashboard/widgets/dashboard_footer.dart';
//
// class AdvertisingScreen extends StatelessWidget {
//
//   const AdvertisingScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: DashboardAppBar(scaffoldKey: _scaffoldKey),
//       drawer: const DashboardDrawer(),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn footer xuống cuối
//         children: [
//           const Expanded(
//             child: Center(
//               child: Text("Advertising Information Content", style: TextStyle(fontSize: 20)),
//             ),
//           ),
//           const DashboardFooter(),
//         ],
//       ),
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:project1/app/models/BaiViet.dart';
// import 'package:project1/app/services/api_baiviet.dart';
// class CreateArticleScreen extends StatefulWidget {
// @override
// _CreateArticleScreenState createState() => _CreateArticleScreenState();
// }
//
// class _CreateArticleScreenState extends State<CreateArticleScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();
//   final TextEditingController _authorController = TextEditingController();
//   final List<String> _imageUrls = [];
//
//   void _addArticle() async {
//     String tieuDe = _titleController.text;
//     String noiDung = _contentController.text;
//     String tacGia = _authorController.text;
//
//     bool success = await ApiService.createArticle(tieuDe, noiDung, tacGia, _imageUrls);
//
//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Thêm bài viết thành công!")));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Thêm bài viết thất bại!")));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Thêm Bài Viết Mới")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(controller: _titleController, decoration: InputDecoration(labelText: "Tiêu đề")),
//             TextField(controller: _contentController, decoration: InputDecoration(labelText: "Nội dung")),
//             TextField(controller: _authorController, decoration: InputDecoration(labelText: "Tác giả")),
//             SizedBox(height: 20),
//             ElevatedButton(onPressed: _addArticle, child: Text("Thêm Bài Viết"))
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:project1/app/models/BaiViet.dart';
import 'package:project1/app/services/api_baiviet.dart';

class AddArticleScreen extends StatefulWidget {
  @override
  _AddArticleScreenState createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final ApiService apiService = ApiService();

  // Danh sách các đoạn nội dung
  List<TextEditingController> _contentControllers = [TextEditingController()];
  // Danh sách các ảnh (URL và mô tả)
  List<Map<String, TextEditingController>> _imageControllers = [
    {
      'url': TextEditingController(),
      'description': TextEditingController(),
    }
  ];

  // Thêm một đoạn nội dung mới
  void _addContentField() {
    setState(() {
      _contentControllers.add(TextEditingController());
    });
  }

  // Thêm một ảnh mới
  void _addImageField() {
    setState(() {
      _imageControllers.add({
        'url': TextEditingController(),
        'description': TextEditingController(),
      });
    });
  }

  // Xóa một đoạn nội dung
  void _removeContentField(int index) {
    setState(() {
      if (_contentControllers.length > 1) {
        _contentControllers[index].dispose();
        _contentControllers.removeAt(index);
      }
    });
  }

  // Xóa một ảnh
  void _removeImageField(int index) {
    setState(() {
      if (_imageControllers.length > 1) {
        _imageControllers[index]['url']?.dispose();
        _imageControllers[index]['description']?.dispose();
        _imageControllers.removeAt(index);
      }
    });
  }

  void _submitArticle() async {
    if (_formKey.currentState!.validate()) {
      // Tạo danh sách ArticleContent từ các đoạn nội dung
      List<ArticleContent> contents = _contentControllers
          .asMap()
          .entries
          .map((entry) => ArticleContent(
        id: 0, // API doesn't require this, set to 0
        articleId: 0, // API doesn't require this, set to 0
        order: entry.key + 1,
        content: entry.value.text,
      ))
          .toList();

      // Tạo danh sách ảnh từ các controller
      List<ArticleImage> images = _imageControllers
          .where((controller) =>
      controller['url']!.text.isNotEmpty &&
          controller['description']!.text.isNotEmpty)
          .map((controller) => ArticleImage(
        id: 0, // API doesn't require this, set to 0
        articleId: 0, // API doesn't require this, set to 0
        url: controller['url']!.text,
        description: controller['description']!.text,
      ))
          .toList();

      // Tạo bài viết mới
      Article newArticle = Article(
        id: 0, // API doesn't require this, set to 0
        title: _titleController.text,
        datePosted: DateTime.now(),
        author: _authorController.text,
        images: images,
        contents: contents,
      );

      bool success = await apiService.createArticle(newArticle);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thêm bài viết thành công!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi khi thêm bài viết!')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    for (var controller in _contentControllers) {
      controller.dispose();
    }
    for (var controller in _imageControllers) {
      controller['url']?.dispose();
      controller['description']?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm bài viết mới')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Tiêu đề',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Nhập tiêu đề' : null,
                ),
                const SizedBox(height: 16),
                // Tác giả
                TextFormField(
                  controller: _authorController,
                  decoration: const InputDecoration(
                    labelText: 'Tác giả',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Nhập tác giả' : null,
                ),
                const SizedBox(height: 16),
                // Nội dung
                const Text(
                  'Nội dung:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._contentControllers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final controller = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            decoration: InputDecoration(
                              labelText: 'Đoạn ${index + 1}',
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) =>
                            value!.isEmpty ? 'Nhập nội dung' : null,
                            maxLines: 5,
                            minLines: 3,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => _removeContentField(index),
                        ),
                      ],
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: _addContentField,
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm đoạn nội dung'),
                ),
                const SizedBox(height: 16),
                // Ảnh
                const Text(
                  'Ảnh:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._imageControllers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final controller = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: controller['url'],
                                decoration: const InputDecoration(
                                  labelText: 'Tên file ảnh (ví dụ: image.jpg)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: controller['description'],
                                decoration: const InputDecoration(
                                  labelText: 'Mô tả ảnh',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => _removeImageField(index),
                        ),
                      ],
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: _addImageField,
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm ảnh'),
                ),
                const SizedBox(height: 20),
                // Nút gửi
                ElevatedButton(
                  onPressed: _submitArticle,
                  child: const Text('Thêm bài viết'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as path;
// import 'package:project1/app/models/BaiViet.dart';
// import 'package:project1/app/services/api_baiviet.dart';
//
// class AddArticleScreen extends StatefulWidget {
//   @override
//   _AddArticleScreenState createState() => _AddArticleScreenState();
// }
//
// class _AddArticleScreenState extends State<AddArticleScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();
//   final TextEditingController _authorController = TextEditingController();
//   final TextEditingController _imageDescController = TextEditingController(); // Bộ điều khiển mô tả ảnh
//   File? _imageFile;
//   final ApiService apiService = ApiService();
//
//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }
//
//   Future<String> _saveImageLocally(File imageFile) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final imagePath = path.join(directory.path, path.basename(imageFile.path));
//     final savedImage = await imageFile.copy(imagePath);
//     return savedImage.path; // Trả về đường dẫn ảnh
//   }
//
//   void _submitArticle() async {
//     if (_formKey.currentState!.validate()) {
//       String imagePath = "";
//       if (_imageFile != null) {
//         imagePath = await _saveImageLocally(_imageFile!);
//       }
//
//       Article newArticle = Article(
//         id: 0,
//         title: _titleController.text,
//         content: _contentController.text,
//         datePosted: DateTime.now().toIso8601String(),
//         author: _authorController.text,
//         images: [
//           ArticleImage(
//             id: 0,
//             articleId: 0,
//             url: imagePath, // Lưu đường dẫn ảnh
//             description: _imageDescController.text, // Lưu mô tả ảnh
//           )
//         ],
//       );
//
//       bool success = await apiService.createArticle(newArticle);
//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Thêm bài viết thành công!')),
//         );
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Lỗi khi thêm bài viết!')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Thêm bài viết mới')),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(labelText: 'Tiêu đề'),
//                 validator: (value) => value!.isEmpty ? 'Nhập tiêu đề' : null,
//               ),
//               TextFormField(
//                 controller: _contentController,
//                 decoration: InputDecoration(labelText: 'Nội dung'),
//                 validator: (value) => value!.isEmpty ? 'Nhập nội dung' : null,
//               ),
//               TextFormField(
//                 controller: _authorController,
//                 decoration: InputDecoration(labelText: 'Tác giả'),
//                 validator: (value) => value!.isEmpty ? 'Nhập tác giả' : null,
//               ),
//               SizedBox(height: 10),
//               _imageFile != null
//                   ? Image.file(_imageFile!, height: 150)
//                   : Text('Chưa chọn ảnh'),
//               TextButton.icon(
//                 icon: Icon(Icons.image),
//                 label: Text('Chọn ảnh từ thư viện'),
//                 onPressed: _pickImage,
//               ),
//               TextFormField(
//                 controller: _imageDescController,
//                 decoration: InputDecoration(labelText: 'Mô tả ảnh'),
//                 validator: (value) => value!.isEmpty ? 'Nhập mô tả ảnh' : null,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitArticle,
//                 child: Text('Thêm bài viết'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
