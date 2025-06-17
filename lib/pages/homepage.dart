import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../widgest/mood_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> moods = const [
    {"emoji": "😄", "label": "Happy"},
    {"emoji": "😡", "label": "Marah"},
    {"emoji": "😢", "label": "Sedih"},
    {"emoji": "😌", "label": "Santai"},
    {"emoji": "🎧", "label": "Fokus"},
  ];

  final TextEditingController moodController = TextEditingController();
  List<dynamic> trendingSongs = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? playingIndex;

  @override
  void initState() {
    super.initState();
    fetchTrendingSongs();

    // Listener untuk deteksi lagu selesai diputar
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        setState(() {
          playingIndex = null;
        });
      }
    });
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

  Future<void> playPreview(String url, int index) async {
    if (playingIndex == index) {
      await _audioPlayer.stop();
      setState(() => playingIndex = null);
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(url));
      setState(() => playingIndex = index);
    }
  }

  @override
  void dispose() {
    moodController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),
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
                      color: Color(0xFF4E342E),
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
                      backgroundColor: const Color.fromARGB(210, 192, 168, 126),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      final mood = moodController.text.trim();
                      if (mood.isNotEmpty) {
                        context.go('/playlist/$mood');
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
              Row(
                children:
                    moods.map((mood) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: MoodButton(
                            emoji: mood['emoji']!,
                            label: mood['label']!,
                            onTap: () {
                              context.go('/playlist/${mood['label']}');
                            },
                          ),
                        ),
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
                          childAspectRatio: 0.75,
                        ),
                    itemBuilder: (context, index) {
                      final song = trendingSongs[index];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBF2),
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
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                            Flexible(
                              child: Text(
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
                            ),
                            Flexible(
                              child: Text(
                                song['artistName'] ?? '',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.brown,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    playingIndex == index
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_fill,
                                    color: Colors.deepOrange,
                                  ),
                                  onPressed:
                                      () => playPreview(
                                        song['previewUrl'],
                                        index,
                                      ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.open_in_new,
                                    color: Colors.green,
                                  ),
                                  onPressed: () async {
                                    final url = song['trackViewUrl'];
                                    if (url != null) {
                                      final uri = Uri.parse(url);
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri);
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Tidak dapat membuka URL',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
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
