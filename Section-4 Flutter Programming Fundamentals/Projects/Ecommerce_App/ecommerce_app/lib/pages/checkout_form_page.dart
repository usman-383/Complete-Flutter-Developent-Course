import 'package:ecommerce_app/models/cart.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ecommerce_app/config.dart';

class CheckoutFormPage extends StatefulWidget {
  final Cart cart;

  const CheckoutFormPage({super.key, required this.cart});

  @override
  State<CheckoutFormPage> createState() => _CheckoutFormPageState();
}

class _CheckoutFormPageState extends State<CheckoutFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });
    // If a publishable key isn't set, fallback to server-only order creation.
    final useStripe =
        stripePublishableKey.isNotEmpty &&
        !stripePublishableKey.contains('YOUR_');

    try {
      if (useStripe) {
        Stripe.publishableKey = stripePublishableKey;

        // Request PaymentIntent client secret from server
        final intentUri = Uri.parse('$serverBaseUrl/create-payment-intent');
        final intentResp = await http.post(
          intentUri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'amount': widget.cart.orderTotal.toDouble(),
            'currency': 'usd',
          }),
        );

        if (intentResp.statusCode != 200) {
          throw Exception('Payment intent creation failed: ${intentResp.body}');
        }

        final intentBody = jsonDecode(intentResp.body);
        final clientSecret = intentBody['clientSecret'];

        // Initialize and present PaymentSheet
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'Demo Shop',
          ),
        );

        await Stripe.instance.presentPaymentSheet();

        // Payment successful — create order on server
        final payload = {
          'customer': {
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'address': _addressController.text.trim(),
            'city': _cityController.text.trim(),
            'postal': _postalController.text.trim(),
          },
          'items': widget.cart.cart
              .map(
                (s) => {
                  'name': s.name,
                  'price': s.price,
                  'quantity': s.quantity,
                },
              )
              .toList(),
          'total': widget.cart.orderTotal,
          'coupon': widget.cart.appliedCoupon,
        };

        final uri = Uri.parse('$serverBaseUrl/orders');
        final resp = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        );

        if (resp.statusCode == 200) {
          final body = jsonDecode(resp.body);
          final id = body['id'] ?? '';

          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Payment & Order Placed'),
              content: Text('Thank you — payment succeeded.\nOrder id: $id'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );

          widget.cart.clearCart();
        } else {
          throw Exception('Order creation failed: ${resp.body}');
        }
      } else {
        // Fallback: create order directly without payment
        final payload = {
          'customer': {
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'address': _addressController.text.trim(),
            'city': _cityController.text.trim(),
            'postal': _postalController.text.trim(),
          },
          'items': widget.cart.cart
              .map(
                (s) => {
                  'name': s.name,
                  'price': s.price,
                  'quantity': s.quantity,
                },
              )
              .toList(),
          'total': widget.cart.orderTotal,
          'coupon': widget.cart.appliedCoupon,
        };

        final uri = Uri.parse('$serverBaseUrl/orders');
        final resp = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        );

        if (resp.statusCode == 200) {
          final body = jsonDecode(resp.body);
          final id = body['id'] ?? '';

          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Order Placed'),
              content: Text(
                'Thank you — your order has been placed.\nOrder id: $id',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );

          widget.cart.clearCart();
        } else {
          throw Exception('Order creation failed: ${resp.body}');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order total: \$${widget.cart.orderTotal}'),
                    if (widget.cart.appliedCoupon.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text('Coupon: ${widget.cart.appliedCoupon}'),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full name',
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter your name'
                            : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Enter your email';
                          }
                          final email = v.trim();
                          if (!email.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(labelText: 'Phone'),
                        keyboardType: TextInputType.phone,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter your phone'
                            : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter your address'
                            : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(labelText: 'City'),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter your city'
                            : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _postalController,
                        decoration: const InputDecoration(
                          labelText: 'Postal code',
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter postal code'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _submitOrder,
                        child: _isLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Place Order'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
