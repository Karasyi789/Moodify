import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      backgroundColor: const Color(0xFFEDE0D4),
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
                        fillColor: const Color(0xFFF5EFE6),
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
                      backgroundColor: const Color.fromARGB(210, 220, 193, 147),
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
              const SizedBox(height: 10),
              trendingSongs.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                    itemCount: trendingSongs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 160,
                          mainAxisSpacing: 11,
                          crossAxisSpacing: 11,
                          childAspectRatio: 0.53,
                        ),
                    itemBuilder: (context, index) {
                      final song = trendingSongs[index];
                      final previewUrl = song['previewUrl'];

                      final spotifyUrl =
                          'https://open.spotify.com/search/${Uri.encodeComponent(song['trackName'] + ' ' + song['artistName'])}';

                      return Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBF2),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: Image.network(
                                  song['artworkUrl100'],
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.music_note,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              song['trackName'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Color(0xFF4E342E),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 2),
                            Text(
                              song['artistName'] ?? '',
                              style: const TextStyle(
                                fontSize: 9.5,
                                color: Colors.brown,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),

                            const Spacer(),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: IconButton(
                                        icon: Icon(
                                          playingIndex == index
                                              ? Icons.pause_circle_filled
                                              : Icons.play_circle_fill,
                                          color: Colors.brown,
                                          size: 20,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed:
                                            () =>
                                                playPreview(previewUrl, index),
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.open_in_new,
                                          color: Colors.green,
                                          size: 20,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () async {
                                          final uri = Uri.parse(spotifyUrl);
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
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '🎵30detik',
                                        style: const TextStyle(
                                          fontSize: 7.5,
                                          color: Colors.grey,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '•lengkap➚',
                                        style: const TextStyle(
                                          fontSize: 7.5,
                                          color: Colors.grey,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
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
