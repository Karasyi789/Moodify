import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlaylistPage extends StatelessWidget {
  final String mood;
  const PlaylistPage({super.key, required this.mood});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.canPop() ? context.pop() : context.go('/');
          },
        ),
        title: Text('Playlist untuk mood: $mood'),
      ),
      body: const Center(child: Text('Daftar playlist akan muncul di sini')),
    );
  }
}
