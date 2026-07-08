import 'package:ecommerce_app/models/cart.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cart favorites', () {
    test('toggleFavorite adds and removes a shoe from favorites', () {
      final cart = Cart();
      final shoe = cart.shoeShop.first;

      expect(cart.isFavorite(shoe), isFalse);

      cart.toggleFavorite(shoe);
      expect(cart.isFavorite(shoe), isTrue);
      expect(cart.favorites, contains(shoe));

      cart.toggleFavorite(shoe);
      expect(cart.isFavorite(shoe), isFalse);
      expect(cart.favorites, isEmpty);
    });
  });
}
