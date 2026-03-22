// main.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 1. Theme and Persistence Manager
class AppTheme {
  // Dark and Light colors based on your UI
  static const darkBackgroundColor = Color(0xFF101010);
  static const darkHeaderColor = Color(0xFF181818);
  static const lightBackgroundColor = Color(0xFFF0F0F0);
  static const lightHeaderColor = Colors.white;

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackgroundColor,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFF7575B), // Red accent
      secondary: Colors.redAccent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lightHeaderColor,
      foregroundColor: Colors.black,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackgroundColor,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFF7575B), // Red accent
      secondary: Colors.redAccent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkHeaderColor,
      foregroundColor: Colors.white,
    ),
  );
}

class ThemeManager {
  static const String _themeKey = 'isDarkMode';
  static final ThemeManager instance = ThemeManager._();
  final ValueNotifier<bool> isDarkMode = ValueNotifier<bool>(true); // Default to dark mode

  ThemeManager._();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    // Default to true (dark) if not set
    isDarkMode.value = prefs.getBool(_themeKey) ?? true;
  }

  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode.value);
  }
}

// 2. Dummy Data Structures
class Product {
  final String imageUrl;
  final String title;
  final String description;
  final double price;

  const Product({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
  });
}

// 3 Products for T-shirt section
const List<Product> tShirtProducts = [
  Product(
    imageUrl: 'https://m.media-amazon.com/images/I/71YyvW7E8EL._AC_UL1500_.jpg',
    title: 'Sportswear Tee',
    description: 'Cotton Sporty T-shirt',
    price: 35.0,
  ),
  Product(
    imageUrl: 'https://m.media-amazon.com/images/I/71E3C5xS7jL._AC_UL1500_.jpg',
    title: 'Graphic Print Tee',
    description: 'Casual Graphic T-shirt',
    price: 40.0,
  ),
  Product(
    imageUrl: 'https://m.media-amazon.com/images/I/71X8X8x-8pL._AC_UL1500_.jpg',
    title: 'Performance Tee',
    description: 'Dry-fit fabric',
    price: 45.0,
  ),
];

// 4 Banners
class BannerData {
  final String imageUrl;
  final String discountText;
  const BannerData(this.imageUrl, this.discountText);
}

const List<BannerData> banners = [
  // Banner image from user image, cropped to remove unnecessary info
  BannerData('https://i.ibb.co/X8gP3kQ/sneaker-puma.png', '40% OFF'), 
  BannerData('https://img.freepik.com/premium-photo/colorful-sport-t-shirt-generative-ai_121287-175.jpg', 'NEW ARRIVALS'), 
  BannerData('https://thumbs.dreamstime.com/b/sportswear-banner-flyer-running-active-lifestyle-advertising-template-design-male-runner-background-copyspace-143093952.jpg', '50% OFF SPORTSWEAR'),
  BannerData('https://thumbs.dreamstime.com/b/sportswear-banner-with-happy-man-active-lifestyle-template-advertising-men-sports-items-store-copy-space-119139556.jpg', 'LIMITED TIME OFFER'),
];

class Voucher {
  final IconData icon;
  final String title;
  const Voucher(this.icon, this.title);
}

const List<Voucher> vouchers = [
  Voucher(CupertinoIcons.ticket, 'Google Play Redeem Code'),
  Voucher(CupertinoIcons.tag, 'Amazon Gift Card'),
  Voucher(CupertinoIcons.gift, 'Unipin Voucher'),
];

// 3. Search functionality implementation
class ProductSearchDelegate extends SearchDelegate<Product?> {
  final List<Product> products;

  ProductSearchDelegate(this.products);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products.where((product) =>
        product.title.toLowerCase().contains(query.toLowerCase()));
    return ListView(
      children: results
          .map((product) => ListTile(
                title: Text(product.title),
                onTap: () {
                  close(context, product);
                },
              ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = products.where((product) =>
        product.title.toLowerCase().contains(query.toLowerCase()));
    return ListView(
      children: suggestions
          .map((product) => ListTile(
                title: Text(product.title),
                onTap: () {
                  query = product.title;
                  showResults(context);
                },
              ))
          .toList(),
    );
  }
}

// 4. Main Application with async init
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await ThemeManager.instance.init();
  } catch (e) {
    // Handle error during SharedPreferences loading (fallback to dark mode)
    debugPrint("Preference load error: $e");
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeManager.instance.isDarkMode,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeManager.instance.isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,
          home: const HomeScreen(),
        );
      },
    );
  }
}

// 5. Main Screen with dynamic categories and theme toggle
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 8),
        color: isDark ? const Color(0xFF101010) : Colors.white,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: 0, // Mocked to 'Home'
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: isDark ? Colors.grey : Colors.black54,
          selectedItemColor: isDark ? Colors.grey : Colors.black87,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.bookmark), label: 'Saved'),
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.cart), label: 'Cart'),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                    color: Color(0xFFF7575B), shape: BoxShape.circle),
                child: const Icon(CupertinoIcons.home, color: Colors.white),
              ),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.heart), label: 'Favorite'),
            BottomNavigationBarItem(
                icon: InkWell(
                  onTap: () {
                    // 6. Navigation to Profile Screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
                    );
                  },
                  child: const Icon(CupertinoIcons.person),
                ),
                label: 'Profile'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header with Theme Toggle
            Container(
              color: isDark ? const Color(0xFF181818) : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            'https://i.ibb.co/p3q6R5b/mounir.png'), // Mock Mounir profile from original image
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello there,',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              )),
                          Text('Mounir',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              )),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // 7. Persisted Dark/Light Mode Toggle
                      IconButton(
                        icon: Icon(isDark
                            ? CupertinoIcons.sun_max // Light icon in dark mode
                            : CupertinoIcons.moon_stars), // Dark icon in light mode
                        onPressed: () => ThemeManager.instance.toggleTheme(),
                      ),
                      const Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(CupertinoIcons.bell),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: CircleAvatar(
                                  radius: 4, backgroundColor: Color(0xFFF7575B)))
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            // Content with T-shirts, Banner, and Redeem Code Shell
            Expanded(
              child: Container(
                color: isDark
                    ? const Color(0xFF101010)
                    : const Color(0xFFF0F0F0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 8. Working Search Bar
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InkWell(
                          onTap: () {
                            showSearch(
                                context: context,
                                delegate: ProductSearchDelegate(tShirtProducts));
                          },
                          child: Container(
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF181818) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(CupertinoIcons.search,
                                        color: isDark ? Colors.grey : Colors.grey[600]),
                                    const SizedBox(width: 8),
                                    Text('Search...',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: isDark ? Colors.grey : Colors.grey[600],
                                        )),
                                  ],
                                ),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Colors.grey[300],
                                ),
                                Icon(CupertinoIcons.slider_horizontal_3,
                                    color: isDark ? Colors.grey : Colors.grey[600]),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // 9. 4-item Banner PageView
                      Container(
                        height: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              onPageChanged: (page) {
                                setState(() {
                                  _currentPage = page;
                                });
                              },
                              itemCount: banners.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        banners[index].imageUrl,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Discount Text on Banner (simplified)
                                    Positioned(
                                      top: 16,
                                      left: 16,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            banners[index].discountText,
                                            style: const TextStyle(
                                              color: Color(0xFFF7575B),
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              height: 1,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            '% OFF',
                                            style: TextStyle(
                                              color: Color(0xFFF7575B),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Shop Now button
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF7575B),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Text('Shop now',
                                            style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            // Banner Pagination Dots
                            Positioned(
                              bottom: 16,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                    banners.length,
                                    (index) => Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                              color: _currentPage == index
                                                  ? const Color(0xFFF7575B)
                                                  : Colors.white.withOpacity(0.5),
                                              shape: BoxShape.circle),
                                        )),
                              ),
                            )
                          ],
                        ),
                      ),
                      // 10. Replaced Men Shoes with T-shirts section
                      _buildSectionHeader(context, "T-shirts", "See All"),
                      _buildProductGrid(tShirtProducts),

                      // 11. Redeem Code Shell section
                      _buildSectionHeader(
                          context, "Redeem code Shell", "Vouchers"),
                      _buildVoucherList(context, isDark),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section header helper
  Widget _buildSectionHeader(BuildContext context, String title, String actionText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          TextButton(
              onPressed: () {},
              child: Text(actionText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ))),
        ],
      ),
    );
  }

  // Generic Product Grid (T-shirt products)
  Widget _buildProductGrid(List<Product> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75, // Adjust for product card ratio
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF181818) : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(CupertinoIcons.heart,
                      color: Colors.white, size: 20),
                ),
              ),
              Expanded(
                child: Center(
                  child: Image.network(product.imageUrl,
                      fit: BoxFit.contain, height: 120),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            )),
                    const SizedBox(height: 4),
                    Text(product.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            )),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Color(0xFFF7575B),
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        const Icon(CupertinoIcons.cart_badge_plus,
                            color: Color(0xFFF7575B)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Redeem Code Vouchers list helper
  Widget _buildVoucherList(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: vouchers.map((voucher) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF181818) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Icon(voucher.icon,
                  color: const Color(0xFFF7575B), size: 30),
              title: Text(voucher.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      )),
              trailing: const Icon(CupertinoIcons.chevron_right, color: Colors.grey),
              onTap: () {},
            ),
          );
        }).toList(),
      ),
    );
  }
}

// 12. Profile Screen with Settings
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock state for the iOS toggle
  bool _notificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: Container(
        color: isDark ? const Color(0xFF101010) : const Color(0xFFF0F0F0),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // 13. iOS Style Toggle implementation
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF181818) : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: const Text('Notifications'),
                trailing: CupertinoSwitch(
                  activeColor: const Color(0xFFF7575B),
                  value: _notificationEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _notificationEnabled = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Setting Items (Order, Address, Payment, etc.)
            _buildSettingItem(context, isDark, CupertinoIcons.list_bullet, 'My order'),
            _buildSettingItem(context, isDark, CupertinoIcons.location, 'Address'),
            _buildSettingItem(context, isDark, CupertinoIcons.creditcard, 'Payment'),
            const SizedBox(height: 16),
            _buildSettingItem(context, isDark, CupertinoIcons.question_circle, 'Help'),
            _buildSettingItem(context, isDark, CupertinoIcons.phone, 'Support'),
            const SizedBox(height: 16),
            _buildSettingItem(
                context, isDark, CupertinoIcons.refresh_bold, 'In app update check'),
          ],
        ),
          ),
        );
      }

  // Setting item helper
  Widget _buildSettingItem(BuildContext context, bool isDark, IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181818) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFF7575B)),
        title: Text(title),
        trailing: const Icon(CupertinoIcons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
