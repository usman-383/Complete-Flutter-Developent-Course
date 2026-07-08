import 'package:ecommerce_app/components/cart_items.dart';
import 'package:ecommerce_app/models/cart.dart';
import 'package:flutter/material.dart';

import 'order_summary_page.dart';

class CartPage extends StatefulWidget {
  final Cart cart;

  const CartPage({super.key, required this.cart});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cart.checkoutSummary(),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    if (widget.cart.appliedCoupon.isNotEmpty) ...[
                      Text(
                        'Applied: ${widget.cart.appliedCoupon} — New total: \$${widget.cart.applyCoupon(widget.cart.appliedCoupon)}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    TextField(
                      controller: _couponController,
                      decoration: InputDecoration(
                        hintText: 'Enter coupon code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        final code = _couponController.text;
                        final discounted = widget.cart.applyCoupon(code);
                        setState(() {});

                        if (widget.cart.appliedCoupon.isNotEmpty) {
                          _couponController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Coupon applied: ${widget.cart.appliedCoupon} — new total \$$discounted',
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Invalid coupon or conditions not met',
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Apply Coupon'),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              widget.cart.clearCart();
                            },
                            icon: const Icon(Icons.remove_shopping_cart),
                            label: const Text('Clear Cart'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return OrderSummaryPage(cart: widget.cart);
                                  },
                                ),
                              );
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Checkout'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
