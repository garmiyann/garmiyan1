/// Product entity representing the business logic product model
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String? sku;
  final String? brand;
  final String categoryId;
  final List<String> images;
  final Map<String, dynamic>? attributes;
  final int stockQuantity;
  final bool isActive;
  final bool isFeatured;
  final double? rating;
  final int reviewCount;
  final double? weight;
  final Map<String, dynamic>? dimensions;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    this.sku,
    this.brand,
    required this.categoryId,
    required this.images,
    this.attributes,
    required this.stockQuantity,
    required this.isActive,
    required this.isFeatured,
    this.rating,
    required this.reviewCount,
    this.weight,
    this.dimensions,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get discount percentage
  double? get discountPercentage {
    if (originalPrice == null || originalPrice! <= 0) return null;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }

  /// Check if product is on sale
  bool get isOnSale => originalPrice != null && originalPrice! > price;

  /// Check if product is in stock
  bool get isInStock => stockQuantity > 0;

  /// Get primary image
  String? get primaryImage => images.isNotEmpty ? images.first : null;

  /// Get formatted price
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  /// Get formatted original price
  String? get formattedOriginalPrice =>
      originalPrice != null ? '\$${originalPrice!.toStringAsFixed(2)}' : null;

  /// Get stock status
  String get stockStatus {
    if (stockQuantity <= 0) return 'Out of Stock';
    if (stockQuantity <= 5) return 'Low Stock';
    return 'In Stock';
  }

  /// Get discount amount
  double get discountAmount {
    if (originalPrice == null) return 0;
    return originalPrice! - price;
  }

  /// Check if product has reviews
  bool get hasReviews => reviewCount > 0;

  /// Get rating display (0-5 stars)
  int get ratingStars {
    if (rating == null) return 0;
    return rating!.round().clamp(0, 5);
  }

  /// Check if product is low stock
  bool get isLowStock => stockQuantity > 0 && stockQuantity <= 5;

  /// Check if product is out of stock
  bool get isOutOfStock => stockQuantity <= 0;

  /// Create a copy with modified fields
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? sku,
    String? brand,
    String? categoryId,
    List<String>? images,
    Map<String, dynamic>? attributes,
    int? stockQuantity,
    bool? isActive,
    bool? isFeatured,
    double? rating,
    int? reviewCount,
    double? weight,
    Map<String, dynamic>? dimensions,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      sku: sku ?? this.sku,
      brand: brand ?? this.brand,
      categoryId: categoryId ?? this.categoryId,
      images: images ?? this.images,
      attributes: attributes ?? this.attributes,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      weight: weight ?? this.weight,
      dimensions: dimensions ?? this.dimensions,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: \$${price.toStringAsFixed(2)})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.originalPrice == originalPrice &&
        other.sku == sku &&
        other.brand == brand &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      price,
      originalPrice,
      sku,
      brand,
      categoryId,
    );
  }
}
