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
      appBar: AppBar(title: const Text("Moodify 🎶"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Bagaimana kabarmu hari ini?:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: moodController,
                    decoration: InputDecoration(
                      hintText: "Contoh: Aku merasa senang...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (moodController.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Mood dikirim: ${moodController.text}"),
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
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 20,
              runSpacing: 20,
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
            const SizedBox(height: 30),
            const Text(
              "🎵 Lagu Trending:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            trendingSongs.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                  itemCount: trendingSongs.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 180,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 3 / 4,
                  ),
                  itemBuilder: (context, index) {
                    final song = trendingSongs[index];
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            song['artistName'] ?? '',
                            style: const TextStyle(fontSize: 12),
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
    );
  }
}
