import 'package:flutter/material.dart';

import 'shoe.dart';

class Cart extends ChangeNotifier {
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
      description:
          'Bouncy cushioning is priced with soft yet supportive foam for rest.',
    ),
  ];

  final List<Shoe> _cartItems = [];
  final List<Shoe> _favorites = [];
  String _searchQuery = '';

  List<Shoe> get shoeShop => _shoeShop;

  List<Shoe> get cart => _cartItems;

  List<Shoe> get favorites => _favorites;

  int get totalPrice {
    return _cartItems.fold(0, (sum, shoe) {
      final price = int.tryParse(shoe.price) ?? 0;
      return sum + (price * shoe.quantity);
    });
  }

  void addToCart(Shoe shoe) {
    final index = _cartItems.indexWhere(
      (item) => item.name == shoe.name && item.imagePath == shoe.imagePath,
    );

    if (index >= 0) {
      _cartItems[index].quantity += 1;
    } else {
      _cartItems.add(
        Shoe(
          name: shoe.name,
          price: shoe.price,
          imagePath: shoe.imagePath,
          description: shoe.description,
        ),
      );
    }

    notifyListeners();
  }

  void increaseQuantity(Shoe shoe) {
    final index = _cartItems.indexWhere(
      (item) => item.name == shoe.name && item.imagePath == shoe.imagePath,
    );
    if (index >= 0) {
      _cartItems[index].quantity += 1;
      notifyListeners();
    }
  }

  void decreaseQuantity(Shoe shoe) {
    final index = _cartItems.indexWhere(
      (item) => item.name == shoe.name && item.imagePath == shoe.imagePath,
    );
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity -= 1;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(Shoe shoe) {
    _cartItems.removeWhere(
      (item) => item.name == shoe.name && item.imagePath == shoe.imagePath,
    );
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void toggleFavorite(Shoe shoe) {
    final index = _favorites.indexWhere(
      (item) => item.name == shoe.name && item.imagePath == shoe.imagePath,
    );

    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(
        Shoe(
          name: shoe.name,
          price: shoe.price,
          imagePath: shoe.imagePath,
          description: shoe.description,
        ),
      );
    }

    notifyListeners();
  }

  bool isFavorite(Shoe shoe) {
    return _favorites.any(
      (item) => item.name == shoe.name && item.imagePath == shoe.imagePath,
    );
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.trim().toLowerCase();
    notifyListeners();
  }

  List<Shoe> filteredShoes(String query) {
    if (query.isEmpty) {
      return _shoeShop;
    }

    return _shoeShop.where((shoe) {
      return shoe.name.toLowerCase().contains(query) ||
          shoe.description.toLowerCase().contains(query);
    }).toList();
  }

  List<Shoe> get visibleShoes => filteredShoes(_searchQuery);

  String checkoutSummary() {
    if (_cartItems.isEmpty) {
      return 'Your cart is empty';
    }

    final itemCount = _cartItems.fold<int>(
      0,
      (sum, shoe) => sum + shoe.quantity,
    );
    return 'Order ready: $itemCount item(s) • Total: \$${totalPrice}';
  }
}
