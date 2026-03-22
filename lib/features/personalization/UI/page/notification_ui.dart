import 'package:clone_netflix/db/notification_db.dart';
import 'package:clone_netflix/features/personalization/UI/page/personalization_ui.dart';
import 'package:clone_netflix/models/movie.dart';
import 'package:flutter/material.dart';


class NotificationScreen extends StatefulWidget {
  final int movieId;
  final MediaType type;
  const NotificationScreen({super.key,required this.movieId,required this.type});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _future = NotificationDb.getNotifications();
  }

  void _refresh() {
    setState(() {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181111),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181111),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MyNetflixScreen(movieId: widget.movieId, type: widget.type)),
            );
          },
        ),
        title: const Text(
          "Thông Báo",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Có lỗi xảy ra", style: TextStyle(color: Colors.white)),
            );
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(
              child: Text(
                "Chưa có thông báo nào",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return CardNotification(
                id: item['id'],
                title: item['title'],
                description: item['description'],
                image: item['image'],
                onDelete: _refresh,
              );
            },
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF181111),
        selectedItemColor: const Color(0xFFE60A15),
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.movie_creation), label: "Clip"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Netflix của tôi"),
        ],
      ),
    );
  }
}

class CardNotification extends StatelessWidget {
  final int id;
  final String title;
  final String description;
  final String image;
  final VoidCallback onDelete;

  const CardNotification({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              image,
              width: 110,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 110,
                height: 70,
                color: Colors.grey,
                child: const Icon(Icons.image, color: Colors.white),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Xóa thông báo?"),
                  content: const Text("Bạn có chắc muốn xóa không?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Hủy"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Xóa"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await NotificationDb.deleteNotifier(id);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã xóa thông báo")),
                );

                onDelete();
              }
            },
          ),
        ],
      ),
    );
  }
}