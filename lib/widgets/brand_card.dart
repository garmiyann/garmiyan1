import 'package:flutter/material.dart';
import '../screens/shopping/shopping_browser_page.dart';

class BrandCard extends StatelessWidget {
  final String image;
  final String url;

  const BrandCard({
    Key? key,
    required this.image,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ShoppingBrowserPage(url: url),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
