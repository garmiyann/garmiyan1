import 'package:flutter/material.dart';
import '../../widgets/brand_card.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shop by Country')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🇺🇸 USA',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildBrandGrid([
              BrandCard(
                  image: 'assets/USA/amazon.png',
                  url: 'https://www.amazon.com'),
              BrandCard(
                  image: 'assets/brands/ebay.png', url: 'https://www.ebay.com'),
              BrandCard(
                  image: 'assets/brands/walmart.png',
                  url: 'https://www.walmart.com'),
            ]),
            const SizedBox(height: 20),
            const Text('🇦🇪 UAE',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildBrandGrid([
              BrandCard(
                  image: 'assets/brands/noon.png', url: 'https://www.noon.com'),
              BrandCard(
                  image: 'assets/brands/carrefour.png',
                  url: 'https://www.carrefouruae.com'),
              BrandCard(
                  image: 'assets/USA/amazon.png', url: 'https://www.amazon.ae'),
            ]),
            const SizedBox(height: 20),
            const Text('🇨🇳 China',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildBrandGrid([
              BrandCard(
                  image: 'assets/brands/aliexpress.png',
                  url: 'https://www.aliexpress.com'),
              BrandCard(
                  image: 'assets/brands/taobao.png',
                  url: 'https://www.taobao.com'),
              BrandCard(
                  image: 'assets/brands/jd.png', url: 'https://www.jd.com'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandGrid(List<BrandCard> brands) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1,
      children: brands,
    );
  }
}
