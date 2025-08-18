/// Product model representing a product in the application
class ProductModel {
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

  const ProductModel({
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

  /// Create ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['original_price'] != null
          ? (json['original_price'] as num).toDouble()
          : null,
      sku: json['sku'] as String?,
      brand: json['brand'] as String?,
      categoryId: json['category_id'] as String,
      images: List<String>.from(json['images'] as List? ?? []),
      attributes: json['attributes'] as Map<String, dynamic>?,
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      rating:
          json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      reviewCount: json['review_count'] as int? ?? 0,
      weight:
          json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      dimensions: json['dimensions'] as Map<String, dynamic>?,
      tags: List<String>.from(json['tags'] as List? ?? []),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert ProductModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'original_price': originalPrice,
      'sku': sku,
      'brand': brand,
      'category_id': categoryId,
      'images': images,
      'attributes': attributes,
      'stock_quantity': stockQuantity,
      'is_active': isActive,
      'is_featured': isFeatured,
      'rating': rating,
      'review_count': reviewCount,
      'weight': weight,
      'dimensions': dimensions,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with modified fields
  ProductModel copyWith({
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
    return ProductModel(
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

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, price: \$${price.toStringAsFixed(2)})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductModel &&
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
