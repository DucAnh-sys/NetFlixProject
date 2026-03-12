import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B0C),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0B0C),
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text(
          "Interstellar",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.share),
          )
        ],
      ),

      body: ListView(
        children: const [

          RatingOverview(),

          SizedBox(height: 20),

          ReviewHeader(),

          ReviewItem(
            name: "Alex Johnson",
            rating: 5,
            time: "2 days ago",
            text:
            "Absolutely incredible cinematography and the plot twists kept me on the edge of my seat.",
          ),

          ReviewItem(
            name: "Sarah Miller",
            rating: 4,
            time: "1 week ago",
            text:
            "Great production value, though the middle episodes felt a bit slow.",
          ),

          ReviewItem(
            name: "David Chen",
            rating: 5,
            time: "2 weeks ago",
            text:
            "The best show I've seen this year. Every frame looks like a painting.",
          ),
        ],
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
class RatingOverview extends StatelessWidget {
  const RatingOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Column(
            children: [
              const Text(
                "4.5",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              Row(
                children: List.generate(
                  5,
                      (index) => const Icon(
                    Icons.star,
                    color: Color(0xFFE60A15),
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "12,450 ratings",
                style: TextStyle(color: Colors.white54),
              )
            ],
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              children: const [
                RatingBarRow(star: "5", percent: 0.7),
                RatingBarRow(star: "4", percent: 0.2),
                RatingBarRow(star: "3", percent: 0.06),
                RatingBarRow(star: "2", percent: 0.02),
                RatingBarRow(star: "1", percent: 0.02),
              ],
            ),
          )
        ],
      ),
    );
  }
}
class RatingBarRow extends StatelessWidget {
  final String star;
  final double percent;

  const RatingBarRow({
    super.key,
    required this.star,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [

          SizedBox(
            width: 20,
            child: Text(
              star,
              style: const TextStyle(color: Colors.white),
            ),
          ),

          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percent,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE60A15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Text(
            "${(percent * 100).toInt()}%",
            style: const TextStyle(color: Colors.white54),
          )
        ],
      ),
    );
  }
}
class ReviewHeader extends StatelessWidget {
  const ReviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: const [

          Text(
            "Reviews",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          Spacer(),

          Text(
            "Most Helpful",
            style: TextStyle(
              color: Color(0xFFE60A15),
            ),
          ),

          Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFFE60A15),
          )
        ],
      ),
    );
  }
}
class ReviewItem extends StatelessWidget {
  final String name;
  final int rating;
  final String time;
  final String text;

  const ReviewItem({
    super.key,
    required this.name,
    required this.rating,
    required this.time,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/150"),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),

                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            rating,
                                (index) => const Icon(
                              Icons.star,
                              color: Color(0xFFE60A15),
                              size: 16,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          time,
                          style: const TextStyle(color: Colors.white54),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 10),

          Text(
            text,
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 10),

          Row(
            children: const [
              Icon(Icons.thumb_up, color: Colors.white54),
              SizedBox(width: 6),
              Text("124", style: TextStyle(color: Colors.white54)),

              SizedBox(width: 20),

              Icon(Icons.thumb_down, color: Colors.white54),
              SizedBox(width: 6),
              Text("12", style: TextStyle(color: Colors.white54)),

              SizedBox(width: 20),

              Icon(Icons.chat_bubble, color: Colors.white54),
              SizedBox(width: 6),
              Text("8", style: TextStyle(color: Colors.white54)),
            ],
          )
        ],
      ),
    );
  }
}