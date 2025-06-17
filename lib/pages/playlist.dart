import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart'; // WAJIB ditambahkan

class PlaylistPage extends StatefulWidget {
  final String mood;

  const PlaylistPage({super.key, required this.mood});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<dynamic> songs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  Future<void> fetchSongs() async {
    final url = Uri.parse(
      'https://itunes.apple.com/search?term=${widget.mood}&entity=song&limit=12',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        songs = data['results'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6), // latar belakang nuansa kopi
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              color: const Color(0xFFD7CCC8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF4E342E),
                    ),
                    onPressed: () {
                      context.go('/'); // Kembali ke halaman utama
                    },
                  ),
                  const Spacer(),
                  Text(
                    'Ciee... yang lagi ${widget.mood.toUpperCase()}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4E342E),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : songs.isEmpty
                      ? const Center(
                        child: Text(
                          "Tidak ada lagu ditemukan",
                          style: TextStyle(color: Color(0xFF6D4C41)),
                        ),
                      )
                      : ListView.builder(
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final song = songs[index];
                          return Card(
                            color: const Color(0xFFEDE0D4),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(song['artworkUrl60']),
                              ),
                              title: Text(
                                song['trackName'] ?? 'No title',
                                style: const TextStyle(
                                  color: Color(0xFF4E342E),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                song['artistName'] ?? '',
                                style: const TextStyle(
                                  color: Color(0xFF6D4C41),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.brown,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
