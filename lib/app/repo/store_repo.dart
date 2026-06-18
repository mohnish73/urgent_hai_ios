import '../model/store/product_model.dart';
import '../services/network/app_url.dart';
import '../services/network/network_api_services.dart';
import '../services/network/response/api_response.dart';
import '../services/network/response/base_api_handler.dart';

class StoreRepo {
  final _api = NetworkApiServices();

  Future<ApiResponse<List<ProductData>>> fetchProducts(int storeId) {
    return ApiHandler.handle(
      apiCall: () => _api.getApi('${AppUrl.getProductById}?ProductId=$storeId'),
      parser: (json) {
        final list = json['Data'] as List? ?? [];
        return list.map((e) => ProductData.fromJson(e as Map<String, dynamic>)).toList();
      },
    );
  }
}
