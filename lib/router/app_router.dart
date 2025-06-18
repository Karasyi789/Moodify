import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/homepage.dart';
import '../pages/playlist.dart';
import '../pages/search.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => HomePage()),
      GoRoute(
        path: '/playlist/:mood',
        builder: (context, state) {
          final mood = state.pathParameters['mood']!;
          return PlaylistPage(mood: mood);
        },
      ),
      GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
    ],
  );
}
