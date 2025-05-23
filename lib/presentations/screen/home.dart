import 'package:marketplace_app/presentations/components/product_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/products.dart'; // Import dari models/products.dart

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Gunakan sampleProducts dari models/products.dart
  late List<Product> _filteredProducts;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(sampleProducts); // Gunakan sampleProducts
  }

  void _onSearchChanged(String query) {
    final q = query.toLowerCase().trim();
    setState(() {
      if (q.isEmpty) {
        _filteredProducts = List.from(sampleProducts); // Gunakan sampleProducts
      } else {
        _filteredProducts = sampleProducts
            .where((p) => p.name.toLowerCase().contains(q))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // custom app bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on, color: Colors.red),
                          SizedBox(width: 4),
                          Text('Alam sutera', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/cart'), 
                    icon: const Icon(Icons.shopping_cart)
                  ),
                ],
              ),
            ),

            // banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://asset.kompas.com/crops/VTMI_hMgGZd-4f12EYYeu4PKTC0=/43x0:1280x825/1200x800/data/photo/2021/09/13/613ede55094fb.jpg',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchCtrl,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Find your pizza here...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // title + view all
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Popular', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, i) {
                    final p = _filteredProducts[i];
                    return ProductCard(
                      imageUrl: p.imageUrl,
                      title: p.name,
                      price: p.price,
                      rating: p.rating,
                      onTap: () => context.push('/detail/${p.id}'),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}