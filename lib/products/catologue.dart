import 'package:cropsync/products/product_page.dart';
import 'package:cropsync/users/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ProductCatalogPage extends StatelessWidget {
  const ProductCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> products = [
      Product(
        id: 1,
        name: 'Soil Testing',
        price: 0.00,
        imageUrls: [
          'https://firebasestorage.googleapis.com/v0/b/cropsync-ed120.appspot.com/o/1.png?alt=media&token=0918c150-b127-4b72-ace1-eeea65bd1812',
          'https://firebasestorage.googleapis.com/v0/b/cropsync-ed120.appspot.com/o/2.png?alt=media&token=7fff3656-f2bb-4e3f-80ae-2b16b9eb9517',
          'https://firebasestorage.googleapis.com/v0/b/cropsync-ed120.appspot.com/o/3.png?alt=media&token=0a662517-2438-4cd0-9e14-3649ffa4491e'
        ],
        description: 'Our soil testing service provides detailed analysis of your soils nutrient content, pH levels, and organic matter. This allows you to tailor fertilizer applications, improve soil health, and optimize crop yields. With precise insights, we help you make informed decisions for sustainable farming. Trust us to enhance your soils potential and boost your agricultural productivity.',
      ),
      Product(
        id: 2,
        name: 'AMF Bio-fertliser',
        price: 299,
        imageUrls: [
          'https://firebasestorage.googleapis.com/v0/b/cropsync-ed120.appspot.com/o/4.png?alt=media&token=6da92dfe-3112-4b43-a32e-e4a69d477bc7',
          'https://firebasestorage.googleapis.com/v0/b/cropsync-ed120.appspot.com/o/5.png?alt=media&token=244adea1-029b-432b-81d8-b9ecdf97b40b',
          'https://firebasestorage.googleapis.com/v0/b/cropsync-ed120.appspot.com/o/6.png?alt=media&token=85a0c633-b927-4fcf-8807-73bd229b5105'
        ],
        description: 'Our AMF Fungi product is a powerful bio-fertilizer designed to enhance plant growth and resilience. By forming symbiotic relationships with plant roots, AMF Fungi significantly improve nutrient and water uptake, boost drought tolerance, and strengthen plants against diseases. Ideal for sustainable agriculture, this product reduces the need for chemical fertilizers while promoting healthier, more robust crops. Enhance your soils natural fertility with our AMF Fungi for greener, more productive farming.',
      ),
    ];

 return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
              backgroundColor: Colors.green[50],
        elevation: 0,
        title: Text('Products & Services',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black)),
        actions: [
              Image.asset(
                'assets/S.png',
                width: 48, // Adjust the width as needed
                height: 48, // Adjust the height as needed
              ),
            ],
      ),
      drawer: const Sidebar( userName: '', profileImagePath: '',),
      body: Column(
        children: [
          Expanded(
            child: _buildProductGrid(context, products),
          ),
        ],
      ),
    );
  }

 

  Widget _buildProductGrid(BuildContext context, List<Product> products) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(context, product);
      },
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(color: Colors.grey[300]),
                    ),
                    Image.network(
                      product.imageUrls.first,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        );
                      },
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '₹ ${product.price.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final int id;
  final String name;
  final double price;
  final List<String> imageUrls;
  final String description; // New description field

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrls,
    required this.description, // Include description in constructor
  });
}