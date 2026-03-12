import 'package:flutter/material.dart';
import 'package:project/features/personalization/UI/page/PersonalizationUI.dart';

import 'package:project/features/personalization/model/NotificationModel.dart';

class NotificationScreen extends StatelessWidget{
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Notificationmodel> notification= Notificationmodel.listNotification();
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
              MaterialPageRoute(
                builder: (_) => const MyNetflixScreen(),
              ),
            );
          },
        ),
        title: const Text(
          "Thông Báo",
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
      ),
      body: ListView.builder(
      itemCount: notification.length,
      itemBuilder: (context, index) {
        final item = notification[index];
        return CardNotification(
          title: item.title,
          description: item.description,
          image: item.image,
        );
      },
    ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF181111), // nền đen Netflix
        selectedItemColor: const Color(0xFFE60A15), // đỏ Netflix
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_creation),
            label: "Clip",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Netflix của tôi",
          ),
        ],
      ),
    );
  }
}
class CardNotification extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const CardNotification({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              image,
              width: 110,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // Nội dung
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
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const Icon(Icons.more_vert, color: Colors.white54),
        ],
      ),
    );
  }
}