import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/products.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  Map<String, int> _cartMap = {};
  static const double deliveryFee = 4.0;
  static const String _prefsKey = 'cart_items';

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_prefsKey) ?? [];
    final map = <String, int>{};
    for (var entry in rawList) {
      final parts = entry.split(':');
      if (parts.length == 2) {
        final id = parts[0];
        final qty = int.tryParse(parts[1]) ?? 1;
        map[id] = qty;
      }
    }
    setState(() => _cartMap = map);
  }

  Future<void> _updateCart(String productId, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    if (quantity <= 0) {
      _cartMap.remove(productId);
    } else {
      _cartMap[productId] = quantity;
    }

    final rawList = _cartMap.entries.map((e) => '${e.key}:${e.value}').toList();
    await prefs.setStringList(_prefsKey, rawList);
    setState(() {});
  }

  void _confirmRemoval(String productId) {
    final product = sampleProducts.firstWhere((p) => p.id == productId);
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Item'),
        content: Text('Remove ${product.name} from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        _updateCart(productId, 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = _cartMap.entries.map((e) {
      final product = sampleProducts.firstWhere((p) => p.id == e.key);
      return _CartItem(
        product: product,
        quantity: e.value,
        onChanged: (qty) => _updateCart(e.key, qty),
        onRemoveConfirmed: () => _confirmRemoval(e.key),
      );
    }).toList();

    final subtotal = items.fold(0.0, (sum, item) => sum + item.product.price * item.quantity);
    final totalItems = items.fold(0, (sum, item) => sum + item.quantity);
    final total = subtotal + deliveryFee;
    final totalQuantity = items.fold<int>(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('Order Details'),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final item = items[index];
                return ListTile(
                  leading: ClipOval(
                    child: Image.network(
                      item.product.imageUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(item.product.name),
                  subtitle: Text('\$${item.product.price.toStringAsFixed(0)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (item.quantity <= 1) {
                            item.onRemoveConfirmed();
                          } else {
                            item.onChanged(item.quantity - 1);
                          }
                        },
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => item.onChanged(item.quantity + 1),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                _SummaryRow(label: 'Item', value: '$totalItems'),
                _SummaryRow(label: 'Price', value: '\$${subtotal.toStringAsFixed(0)}'),
                _SummaryRow(label: 'Delivery', value: '\$${deliveryFee.toStringAsFixed(0)}'),
                const SizedBox(height: 8),
                _SummaryRow(
                  label: 'Total',
                  value: '\$${total.toStringAsFixed(0)}',
                  isTotal: true,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // proceed to checkout
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Berhasil checkout $totalQuantity pizza, total harga \$${total.toStringAsFixed(0)}',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Checkout',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class _CartItem {
  final Product product;
  final int quantity;
  final ValueChanged<int> onChanged;
  final VoidCallback onRemoveConfirmed;
  const _CartItem({
    required this.product,
    required this.quantity,
    required this.onChanged,
    required this.onRemoveConfirmed,
  });
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = isTotal
        ? const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
        : const TextStyle(fontSize: 14);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}
