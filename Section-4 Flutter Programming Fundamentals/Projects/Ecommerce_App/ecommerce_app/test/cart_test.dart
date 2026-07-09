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
      expect(cart.favorites, hasLength(1));
      expect(cart.favorites.first.name, shoe.name);

      cart.toggleFavorite(shoe);
      expect(cart.isFavorite(shoe), isFalse);
      expect(cart.favorites, isEmpty);
    });

    test('filteredShoes returns only matching products', () {
      final cart = Cart();

      final results = cart.filteredShoes('jordan');

      expect(results, hasLength(1));
      expect(results.first.name, 'Air Jordan');
    });

    test('checkoutSummary returns a purchase summary', () {
      final cart = Cart();
      cart.addToCart(cart.shoeShop.first);

      final summary = cart.checkoutSummary();

      expect(summary, contains('Order ready'));
      expect(summary, contains('1'));
    });

    test('applyCoupon reduces the total for a valid code', () {
      final cart = Cart();
      cart.addToCart(cart.shoeShop.first);

      final discountedTotal = cart.applyCoupon('SAVE10');

      expect(discountedTotal, 226);
      expect(cart.appliedCoupon, 'SAVE10');
    });
  });
}
