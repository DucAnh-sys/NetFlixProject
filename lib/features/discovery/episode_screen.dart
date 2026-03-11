import 'package:flutter/material.dart';

class EpisodeScreen extends StatefulWidget {
  final String movieTitle;
  const EpisodeScreen({super.key, required this.movieTitle});

  @override
  State<EpisodeScreen> createState() => _EpisodeScreenState();
}

class _EpisodeScreenState extends State<EpisodeScreen> {
  String selectedSeason = 'Mùa 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.movieTitle,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nút chọn Mùa (Season Picker)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: () => _showSeasonPicker(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedSeason,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),

          // Danh sách tập phim
          Expanded(
            child: ListView.builder(
              itemCount: 8, // Giả định có 8 tập mỗi mùa
              itemBuilder: (context, index) {
                return _buildEpisodeItem(index + 1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodeItem(int episodeNumber) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Ảnh thumbnail tập phim
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/image/image.jpg', // Thay bằng ảnh tập phim
                      width: 130,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                    const Icon(Icons.play_circle_outline, color: Colors.white, size: 30),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Thông tin tập
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$episodeNumber. Tên tập phim $episodeNumber',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      '45 phút',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.file_download_outlined, color: Colors.white),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Mô tả ngắn gọn về nội dung của tập phim này để người dùng nắm bắt được diễn biến chính...',
            style: TextStyle(color: Colors.grey, fontSize: 13),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Hàm hiển thị Bottom Sheet để chọn Mùa
  void _showSeasonPicker(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color(0xFF262626),
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Mùa 1', 'Mùa 2', 'Mùa 3', 'Mùa 4'].map((season) {
              return ListTile(
                title: Center(
                  child: Text(
                    season,
                    style: TextStyle(
                      color: season == selectedSeason ? Colors.white : Colors.grey,
                      fontWeight: season == selectedSeason ? FontWeight.bold : FontWeight.normal,
                      fontSize: 18,
                    ),
                  ),
                ),
                onTap: () {
                  setState(() => selectedSeason = season);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}