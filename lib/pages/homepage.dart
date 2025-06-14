import 'package:flutter/material.dart';
import '../widgest/mood_button.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, String>> moods = const [
    {"emoji": "😄", "label": "happy"},
    {"emoji": "😢", "label": "sad"},
    {"emoji": "😌", "label": "relax"},
    {"emoji": "🎧", "label": "focus"},
  ];

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
