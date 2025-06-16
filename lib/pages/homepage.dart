import 'package:flutter/material.dart';
import '../widgest/mood_button.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Map<String, String>> moods = const [
    {"emoji": "😄", "label": "happy"},
    {"emoji": "😢", "label": "sad"},
    {"emoji": "😌", "label": "relax"},
    {"emoji": "🎧", "label": "focus"},
  ];

  final TextEditingController moodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Moodify 🎶"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    backgroundColor: Colors.purple.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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
          ],
        ),
      ),
    );
  }
}
