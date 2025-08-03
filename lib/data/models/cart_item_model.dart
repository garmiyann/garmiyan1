/// Cart item model representing an item in the shopping cart
class CartItemModel {
  final String id;
  final String productId;
  final String userId;
  final int quantity;
  final double unitPrice;
  final Map<String, dynamic>? selectedVariants;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.quantity,
    required this.unitPrice,
    this.selectedVariants,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create CartItemModel from JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      userId: json['user_id'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unit_price'] as num).toDouble(),
      selectedVariants: json['selected_variants'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert CartItemModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'selected_variants': selectedVariants,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with modified fields
  CartItemModel copyWith({
    String? id,
    String? productId,
    String? userId,
    int? quantity,
    double? unitPrice,
    Map<String, dynamic>? selectedVariants,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      selectedVariants: selectedVariants ?? this.selectedVariants,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get total price for this cart item
  double get totalPrice => unitPrice * quantity;

  /// Get formatted total price
  String get formattedTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';

  @override
  String toString() {
    return 'CartItemModel(id: $id, productId: $productId, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItemModel &&
        other.id == id &&
        other.productId == productId &&
        other.userId == userId &&
        other.quantity == quantity &&
        other.unitPrice == unitPrice;
  }

  @override
  int get hashCode => Object.hash(id, productId, userId, quantity, unitPrice);
}
