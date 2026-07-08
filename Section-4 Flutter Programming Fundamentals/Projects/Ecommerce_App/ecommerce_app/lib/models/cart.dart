import 'shoe.dart';

class Cart {
  final List<Shoe> _shoeShop = [
    Shoe(
      name: 'Zoom Freak',
      price: '236',
      imagePath: 'lib/images/image_1.png',
      description: 'The forward-thinking design of his latest signature shoe.',
    ),
    Shoe(
      name: 'Air Jordan',
      price: '220',
      imagePath: 'lib/images/image_2.jpg',
      description: 'You\'ve got the hope and the speed-lac up in shoes.',
    ),
    Shoe(
      name: 'KD Treys',
      price: '240',
      imagePath: 'lib/images/image_3.jpg',
      description: 'A secure midfoot scrip is suited for scoring.',
    ),
    Shoe(
      name: 'Kyrie 6',
      price: '190',
      imagePath: 'lib/images/image_4.png',
      description: 'Bouncy cushioning is priced with soft yet supportive foam for rest.',
    ),
  ];

  final List<Shoe> _cartItems = [];

  List<Shoe> get shoeShop => _shoeShop;

  List<Shoe> get cart => _cartItems;

  int get totalPrice {
    return _cartItems.fold(0, (sum, shoe) {
      final price = int.tryParse(shoe.price) ?? 0;
      return sum + price;
    });
  }

  void addToCart(Shoe shoe) {
    _cartItems.add(shoe);
  }

  void removeFromCart(Shoe shoe) {
    _cartItems.remove(shoe);
  }
}
