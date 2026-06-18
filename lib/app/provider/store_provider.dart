import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../core/config/app_config.dart';
import '../model/store/product_model.dart';
import '../repo/store_repo.dart';
import '../services/network/response/api_response.dart';

class StoreProvider extends ChangeNotifier {
  final _repo = StoreRepo();

  static const _wishKey = 'wishListData';
  static const _cartKey = 'productCartData';

  Box get _box => Hive.box(AppConfig.storeBox);

  StoreProvider() {
    _loadFromStorage();
  }

  void _loadFromStorage() {
    // Wishlist
    final wishJson = _box.get(_wishKey) as String?;
    if (wishJson != null) {
      final list = jsonDecode(wishJson) as List;
      _wishlist.addAll(
          list.map((e) => ProductData.fromJson(e as Map<String, dynamic>)));
    }
    // Cart
    final cartJson = _box.get(_cartKey) as String?;
    if (cartJson != null) {
      final list = jsonDecode(cartJson) as List;
      _cart.addAll(
          list.map((e) => ProductData.fromJson(e as Map<String, dynamic>)));
    }
  }

  void _saveWishlist() {
    _box.put(_wishKey,
        jsonEncode(_wishlist.map((p) => p.toJson()).toList()));
  }

  void _saveCart() {
    _box.put(_cartKey,
        jsonEncode(_cart.map((p) => p.toJson()).toList()));
  }

  // ── Products ─────────────────────────────────────────────
  ApiResponse<List<ProductData>> products = ApiResponse.idle();

  Future<void> fetchProducts([int storeId = 3]) async {
    products = ApiResponse.loading();
    notifyListeners();
    products = await _repo.fetchProducts(storeId);
    notifyListeners();
  }

  // ── Cart ─────────────────────────────────────────────────
  final List<ProductData> _cart = [];
  List<ProductData> get cart => List.unmodifiable(_cart);

  int get cartItemCount => _cart.fold(0, (sum, p) => sum + p.noQty);
  double get cartSubTotal => _cart.fold(0.0, (sum, p) => sum + p.price * p.noQty);
  double get cartTotal => cartSubTotal + 10.0;

  bool isInCart(int productId) => _cart.any((p) => p.productId == productId);

  int getCartQty(int productId) {
    final match = _cart.where((p) => p.productId == productId);
    return match.isEmpty ? 0 : match.first.noQty;
  }

  void addToCart(ProductData product) {
    final index = _cart.indexWhere((p) => p.productId == product.productId);
    if (index >= 0) {
      if (_cart[index].noQty < 5) {
        _cart[index].noQty++;
      }
    } else {
      _cart.add(ProductData(
        productId: product.productId,
        storeId: product.storeId,
        categoryId: product.categoryId,
        storeType: product.storeType,
        price: product.price,
        name: product.name,
        sellingPrice: product.sellingPrice,
        mrp: product.mrp,
        unit: product.unit,
        quantity: product.quantity,
        isAvailable: product.isAvailable,
        productImageUrl: product.productImageUrl,
        noQty: 1,
      ));
    }
    _saveCart();
    notifyListeners();
  }

  void decreaseFromCart(int productId) {
    final index = _cart.indexWhere((p) => p.productId == productId);
    if (index < 0) return;
    _cart[index].noQty--;
    if (_cart[index].noQty <= 0) _cart.removeAt(index);
    _saveCart();
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _cart.removeWhere((p) => p.productId == productId);
    _saveCart();
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _saveCart();
    notifyListeners();
  }

  // ── Wishlist ─────────────────────────────────────────────
  final List<ProductData> _wishlist = [];
  List<ProductData> get wishlist => List.unmodifiable(_wishlist);

  bool isInWishlist(int productId) =>
      _wishlist.any((p) => p.productId == productId);

  void toggleWishlist(ProductData product) {
    final index = _wishlist.indexWhere((p) => p.productId == product.productId);
    if (index >= 0) {
      _wishlist.removeAt(index);
    } else {
      _wishlist.add(product);
    }
    _saveWishlist();
    notifyListeners();
  }
}
