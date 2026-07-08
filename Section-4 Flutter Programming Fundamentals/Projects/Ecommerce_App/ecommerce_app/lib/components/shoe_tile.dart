import 'package:flutter/material.dart';

import '../models/shoe.dart';

class shoeTile extends StatelessWidget {
  Shoe shoe;
  shoeTile({super.key, required this.shoe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 25.0),
      width: 280,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        //shoe pic
        Image.asset(shoe.imagePath),

        // description

        //price + details

        //button to add to cart
      ),
    );
  }
}
