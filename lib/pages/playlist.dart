import 'package:flutter/material.dart';

class PlaylistPage extends StatelessWidget {
  final String mood;
  const PlaylistPage({super.key, required this.mood});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Playlist untuk mood: $mood')),
      body: const Center(child: Text('Daftar playlist akan muncul di sini')),
    );
  }
}
