import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/products.dart';

class DetailPage extends ConsumerStatefulWidget {
  final String id;

  const DetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  int _quantity = 1;

  void _increment() => setState(() => _quantity++);
  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  @override
  Widget build(BuildContext context) {
    final product = sampleProducts.firstWhere((p) => p.id == widget.id);

    const duration = '15 Mins';
    const calories = '320 Kal';
    const reviews = '1.7k Reviews';
    const description = '''
Most Mushroom Pizzas Go For A White Sauce. But nope, not here! I wanted my favorite pizza sauce and a heap of seasonal, delicious veggies. This pizza is layered in sauce (that comes together in seconds), quick sautéed mushrooms, and dollops of creamy mozzarella.
''';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Order Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // pizza image
              Center(
                child: ClipOval(
                  child: Image.network(
                    product.imageUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 60,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // title
              Text(
                product.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 4),
                      Text(duration),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Row(
                    children: [
                      const Icon(Icons.whatshot, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(calories),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${product.rating} ($reviews)'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // price + quantity
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      // minus
                      InkWell(
                        onTap: _decrement,
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.remove, size: 16),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$_quantity',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 12),
                      // plus
                      InkWell(
                        onTap: _increment,
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.add, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // about section
              const Text(
                'About Pizza',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 80), // space for the bottom button
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              const key = 'cart_items';

              // 1) load existing list or start fresh
              final List<String> raw = prefs.getStringList(key) ?? [];

              // 2) remove any old entry for this product
              raw.removeWhere((e) => e.split(':')[0] == product.id);

              // 3) add new entry "id:quantity"
              raw.add('${product.id}:$_quantity');

              // 4) persist back
              await prefs.setStringList(key, raw);

              // 5) show dialog
              if (mounted) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Added to Cart'),
                    content: Text('${product.name} ($_quantity pcs) added.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();       // close
                          context.go('/home');               // back home
                        },
                        child: const Text('Continue Shopping'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();       // close
                          context.go('/cart');               // go to cart
                        },
                        child: const Text('View Cart'),
                      ),
                    ],
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Add To Cart', style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }
}