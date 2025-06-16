import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgest/mood_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> moods = const [
    {"emoji": "😄", "label": "happy"},
    {"emoji": "😢", "label": "sad"},
    {"emoji": "😌", "label": "relax"},
    {"emoji": "🎧", "label": "focus"},
  ];

  final TextEditingController moodController = TextEditingController();
  List<dynamic> trendingSongs = [];

  @override
  void initState() {
    super.initState();
    fetchTrendingSongs();
  }

  Future<void> fetchTrendingSongs() async {
    final url = Uri.parse(
      'https://itunes.apple.com/search?term=top&entity=song&limit=10',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        trendingSongs = data['results'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6), // 🍦 Cream background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Hi friend 👋",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4E342E), // 🟤 Coklat tua
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      size: 28,
                      color: Color(0xFF6D4C41),
                    ),
                    onPressed: () {
                      context.go('/search');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Bagaimana perasaanmu hari ini?",
                style: TextStyle(fontSize: 16, color: Color(0xFF6D4C41)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: moodController,
                      decoration: InputDecoration(
                        hintText: "Contoh: Aku merasa senang...",
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFFEDE0D4),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFFB3925A,
                      ), // ☕ Coffee brown
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (moodController.text.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Mood dikirim: ${moodController.text}",
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text("Kirim"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Atau pilih emoji mood-mu:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4E342E),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children:
                    moods.map((mood) {
                      return MoodButton(
                        emoji: mood['emoji']!,
                        label: mood['label']!,
                        onTap: () {
                          context.go('/playlist/${mood['label']}');
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 32),
              const Row(
                children: [
                  Icon(Icons.local_fire_department, color: Colors.deepOrange),
                  SizedBox(width: 6),
                  Text(
                    "Lagu Trending",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4E342E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              trendingSongs.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                    itemCount: trendingSongs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 180,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 3 / 4,
                        ),
                    itemBuilder: (context, index) {
                      final song = trendingSongs[index];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFFFFBF2,
                          ), // 🍪 light coffee card
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                song['artworkUrl100'],
                                height: 80,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              song['trackName'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF4E342E),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              song['artistName'] ?? '',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.brown,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
