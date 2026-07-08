import 'package:ecommerce_app/components/cart_items.dart';
import 'package:ecommerce_app/models/cart.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final Cart cart;

  const CartPage({super.key, required this.cart});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartItems = widget.cart.cart;

    return AnimatedBuilder(
      animation: widget.cart,
      builder: (context, _) {
        if (cartItems.isEmpty) {
          return const Center(child: Text('Your cart is empty'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Items: ${cartItems.length}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Total: \$${widget.cart.totalPrice}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final shoe = cartItems[index];
                    return CartItems(
                      shoe: shoe,
                      onIncrease: () {
                        widget.cart.increaseQuantity(shoe);
                      },
                      onDecrease: () {
                        widget.cart.decreaseQuantity(shoe);
                      },
                      onRemove: () {
                        widget.cart.removeFromCart(shoe);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
