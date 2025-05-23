import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentations/screen/cart.dart';
import '../presentations/screen/detail.dart';
import '../presentations/screen/home.dart';

/// Provider yang memberi GoRouter ke seluruh app
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',    // mulai di home
    routes: [
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      GoRoute(
        path: '/detail/:id',
        name: 'detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DetailPage(id: id);
        },
      ),
      
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartPage(),
      ),
    ],
    // halaman 404 sederhana
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: Center(child: Text('Page not found: ${state.error}')),
    ),
  );
});

// Hapus main() function dari sini karena sudah ada di main.dart