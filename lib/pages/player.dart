import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlayerPage extends StatelessWidget {
  final String playlistId;
  const PlayerPage({super.key, required this.playlistId});

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

        title: const Text("Player"),
      ),
      body: Center(
        child: Text('Player untuk playlist ID: $playlistId (part 5)'),
      ),
    );
  }
}
