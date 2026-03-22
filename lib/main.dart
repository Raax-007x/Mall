import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  // Global Error Handling
  runZonedGuarded(() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('Caught Flutter Error: ${details.exception}');
    };
    runApp(const MyApp());
  }, (error, stack) {
    debugPrint('Caught Async Error: $error');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoe Store UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.redAccent,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Hello there,', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text('Mounir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.wb_sunny_outlined, color: Colors.grey),
                      const SizedBox(width: 15),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          shape: BoxShape.circle,
                        ),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search...',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    Icon(Icons.filter_alt_outlined, color: Colors.grey),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Banner
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=500&auto=format&fit=crop&q=60'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Shop now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('40', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                          Text('% OFF', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Popular Brands
              SectionHeader(title: 'Popular brands', onSeeAll: () {}),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    BrandIcon(icon: Icons.sports_tennis),
                    BrandIcon(icon: Icons.sports_basketball),
                    BrandIcon(icon: Icons.sports_volleyball),
                    BrandIcon(icon: Icons.sports_soccer),
                    BrandIcon(icon: Icons.sports_golf),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Men's Shoes
              SectionHeader(title: "Men's Shoes", onSeeAll: () {}),
              const SizedBox(height: 10),
              SizedBox(
                height: 260,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ProductCard(
                      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&auto=format&fit=crop&q=60',
                      title: 'Running Shoes',
                      colors: 5,
                      price: 250,
                    ),
                    ProductCard(
                      imageUrl: 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=500&auto=format&fit=crop&q=60',
                      title: 'White Sneakers',
                      colors: 3,
                      price: 230,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Custom Bottom Navigation
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: const Color(0xFF121212),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.bookmark_border, color: Colors.grey),
            const Icon(Icons.shopping_cart_outlined, color: Colors.grey),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.home, color: Colors.white),
            ),
            const Icon(Icons.favorite_border, color: Colors.grey),
            const Icon(Icons.person_outline, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// Reusable Section Header
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const SectionHeader({super.key, required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        GestureDetector(
          onTap: onSeeAll,
          child: const Text('See All', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ),
      ],
    );
  }
}

// Reusable Brand Icon Widget
class BrandIcon extends StatelessWidget {
  final IconData icon;
  const BrandIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      width: 60,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 30),
    );
  }
}

// Reusable Product Card Widget
class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int colors;
  final int price;

  const ProductCard({super.key, required this.imageUrl, required this.title, required this.colors, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: const Icon(Icons.favorite_border, color: Colors.white, size: 20),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(imageUrl, height: 100, width: 120, fit: BoxFit.cover),
            ),
          ),
          const Spacer(),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 5),
          Row(
            children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.redAccent, size: 12)),
          ),
          const SizedBox(height: 5),
          Text('$colors Colors', style: const TextStyle(color: Colors.grey, fontSize: 10)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$$price', style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
              const Icon(Icons.shopping_cart_outlined, color: Colors.redAccent, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}
