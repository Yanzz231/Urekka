class Product {
  final String id, name, imageUrl;
  final double price;
  final int rating;

  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.rating,
  });
}

const sampleProducts = [
  Product(
    id: '1',
    name: 'Coffe Caramel Macchiato',
    imageUrl:
    'https://flash-coffee.com/id/wp-content/uploads/sites/13/2023/06/CARAMEL-MACCHIATO-2.jpg',
    price: 80,
    rating: 4,
  ),
  Product(
    id: '2',
    name: 'Coffe Cappucino',
    imageUrl:
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTe-ZcfFt5stxFBb1GwHuOT-BC_F9VWyjCXcA&s',
    price: 50,
    rating: 4,
  ),
  Product(
    id: '3',
    name: 'Coffe Pistachio',
    imageUrl:
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYqkyP-KEM5EBtlp5t0MiyGQo5J-pyvroA9A&s',
    price: 60,
    rating: 4,
  ),
  Product(
    id: '4',
    name: 'Coffe Americano',
    imageUrl:
    'https://hips.hearstapps.com/delish/assets/cm/15/10/54f94da13cfcd_-_starbucks-cup-blog.jpg',
    price: 50,
    rating: 4,
  ),
];
