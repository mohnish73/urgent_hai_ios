class ProductData {
  final int productId;
  final int storeId;
  final int categoryId;
  final String storeType;
  final double price;
  final String name;
  final double sellingPrice;
  final double mrp;
  final String unit;
  final int quantity;
  final bool isAvailable;
  final String productImageUrl;
  int noQty;

  ProductData({
    required this.productId,
    required this.storeId,
    required this.categoryId,
    required this.storeType,
    required this.price,
    required this.name,
    required this.sellingPrice,
    required this.mrp,
    required this.unit,
    required this.quantity,
    required this.isAvailable,
    required this.productImageUrl,
    this.noQty = 0,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        productId: (json['ProductId'] as num?)?.toInt() ?? 0,
        storeId: (json['StoreId'] as num?)?.toInt() ?? 0,
        categoryId: (json['CategoryId'] as num?)?.toInt() ?? 0,
        storeType: json['StoreType'] as String? ?? '',
        price: (json['Price'] as num?)?.toDouble() ?? 0.0,
        name: json['Name'] as String? ?? '',
        sellingPrice: (json['SellingPrice'] as num?)?.toDouble() ?? 0.0,
        mrp: (json['MRP'] as num?)?.toDouble() ?? 0.0,
        unit: json['Unit'] as String? ?? '',
        quantity: (json['Quantity'] as num?)?.toInt() ?? 0,
        isAvailable: json['IsAvailable'] as bool? ?? true,
        productImageUrl: json['ProductImageUrl'] as String? ?? '',
        noQty: (json['noQty'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'ProductId': productId,
        'StoreId': storeId,
        'CategoryId': categoryId,
        'StoreType': storeType,
        'Price': price,
        'Name': name,
        'SellingPrice': sellingPrice,
        'MRP': mrp,
        'Unit': unit,
        'Quantity': quantity,
        'IsAvailable': isAvailable,
        'ProductImageUrl': productImageUrl,
        'noQty': noQty,
      };
}
