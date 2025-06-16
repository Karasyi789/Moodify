import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];
  bool isLoading = false;

  Future<void> searchSongs(String query) async {
    if (query.isEmpty) return;
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
      'https://itunes.apple.com/search?term=$query&entity=song&limit=24',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        searchResults = data['results'];
      });
    } else {
      setState(() {
        searchResults = [];
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6), // 🍦 Cream background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFF4E342E),
        ), // 🟤 Icon warna
        title: const Text(
          "Cari Lagu 🔎",
          style: TextStyle(
            color: Color(0xFF4E342E),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🔍 Input Pencarian
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari lagu favoritmu...',
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
                    onSubmitted: searchSongs,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB3925A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => searchSongs(_searchController.text),
                  child: const Text("Cari"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (isLoading) const CircularProgressIndicator(),

            if (!isLoading)
              Expanded(
                child:
                    searchResults.isEmpty
                        ? const Center(
                          child: Text(
                            "Belum ada hasil pencarian.",
                            style: TextStyle(
                              color: Color(0xFF6D4C41),
                              fontSize: 16,
                            ),
                          ),
                        )
                        : GridView.builder(
                          itemCount: searchResults.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 180,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 3 / 4,
                              ),
                          itemBuilder: (context, index) {
                            final song = searchResults[index];
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
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                  Text(
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
                                  const SizedBox(height: 4),
                                  Text(
                                    song['artistName'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.brown,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
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
