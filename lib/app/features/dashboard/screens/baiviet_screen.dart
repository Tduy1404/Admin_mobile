// import 'package:flutter/material.dart';
// import 'package:project1/app/models/BaiViet.dart';
// import 'package:project1/app/services/api_baiviet.dart';
// import 'package:project1/app/features/dashboard/widgets/dashboard_appbar.dart';
// import 'package:project1/app/features/dashboard/widgets/dashboard_drawer.dart';
// import 'package:project1/app/features/dashboard/widgets/dashboard_footer.dart';
// import 'package:project1/app/features/dashboard/screens/advertising_info.dart';
//
// class ArticleScreen extends StatefulWidget {
//   @override
//   _ArticleScreenState createState() => _ArticleScreenState();
// }
//
// class _ArticleScreenState extends State<ArticleScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: DashboardAppBar(scaffoldKey: _scaffoldKey),
//       drawer: const DashboardDrawer(),
//       body: Column(
//         children: [
//           const Expanded(child: ArticleBody()), // Nội dung bài viết
//           const DashboardFooter(), // Footer giống Dashboard
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddArticleScreen()),
//           );
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.blue,
//       ),
//     );
//   }
// }
//
// class ArticleBody extends StatefulWidget {
//   const ArticleBody({Key? key}) : super(key: key);
//
//   @override
//   _ArticleBodyState createState() => _ArticleBodyState();
// }
//
// class _ArticleBodyState extends State<ArticleBody> {
//   late Future<List<Article>> futureArticles;
//   final ApiService apiService = ApiService();
//
//   @override
//   void initState() {
//     super.initState();
//     futureArticles = apiService.fetchArticles();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Article>>(
//       future: futureArticles,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Lỗi: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(child: Text('Không có bài viết nào.'));
//         }
//
//         List<Article> articles = snapshot.data!;
//         return ListView.builder(
//           itemCount: articles.length,
//           itemBuilder: (context, index) {
//             final article = articles[index];
//             final bool hasImage = article.images.isNotEmpty;
//             final String imageName = hasImage ? article.images.first.url : '';
//             final String localImagePath = 'lib/app/images/$imageName';
//
//             return Card(
//               margin: EdgeInsets.all(10),
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.all(10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ListTile(
//                       title: Text(
//                         article.title,
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Ngày phát hành: ${article.datePosted}'),
//                           Text('Tác giả: ${article.author}'),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       child: Text(article.content),
//                     ),
//                     SizedBox(height: 10),
//                     if (hasImage)
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.asset(
//                           localImagePath,
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                           height: 200,
//                         ),
//                       ),
//                     SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:project1/app/models/BaiViet.dart';
import 'package:project1/app/services/api_baiviet.dart';
import 'package:project1/app/features/dashboard/widgets/dashboard_appbar.dart';
import 'package:project1/app/features/dashboard/widgets/dashboard_drawer.dart';
import 'package:project1/app/features/dashboard/widgets/dashboard_footer.dart';
import 'package:project1/app/features/dashboard/screens/ArticleListScreen.dart';
import 'package:project1/app/features/dashboard/screens/advertising_info.dart';
import 'package:project1/app/features/dashboard/screens/EditArticleScreen.dart';

class ArticleScreen extends StatefulWidget {
  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<Article>> futureArticles;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureArticles = apiService.fetchArticles();
  }

  void _refreshArticles() {
    setState(() {
      futureArticles = apiService.fetchArticles();
    });
  }

  Future<void> _deleteArticle(int articleId) async {
    bool success = await apiService.deleteArticle(articleId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa bài viết thành công!')),
      );
      setState(() {
        futureArticles = apiService.fetchArticles(); // Cập nhật danh sách
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa bài viết!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: DashboardAppBar(scaffoldKey: _scaffoldKey),
      drawer: const DashboardDrawer(),
      body: Column(
        children: [
          Expanded(child: ArticleBody(futureArticles: futureArticles, onRefresh: _refreshArticles, onDelete: _deleteArticle)),
          const DashboardFooter(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddArticleScreen()),
          );

          if (result == true) {
            _refreshArticles();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class ArticleBody extends StatelessWidget {
  final Future<List<Article>> futureArticles;
  final VoidCallback onRefresh;
  final Function(int) onDelete; // Thêm callback cho xóa

  const ArticleBody({
    Key? key,
    required this.futureArticles,
    required this.onRefresh,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: futureArticles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có bài viết nào.'));
        }

        List<Article> articles = snapshot.data!;
        return ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];

            return Card(
              margin: EdgeInsets.all(10),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  article.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text('Tác giả: ${article.author} - Ngày: ${article.datePosted}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailScreen(article: article),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditArticleScreen(article: article),
                          ),
                        );

                        if (result == true) {
                          onRefresh();
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        // Xác nhận trước khi xóa
                        bool? confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Xác nhận xóa'),
                            content: Text('Bạn có chắc muốn xóa bài viết "${article.title}"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('Xóa'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await onDelete(article.id); // Gọi hàm xóa
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}