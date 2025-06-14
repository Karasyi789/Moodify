import 'package:flutter/material.dart';

class PlayerPage extends StatelessWidget {
  final String playlistId;
  const PlayerPage({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Player")),
      body: Center(
        child: Text('Player untuk playlist ID: $playlistId (part 5)'),
      ),
    );
  }
}
