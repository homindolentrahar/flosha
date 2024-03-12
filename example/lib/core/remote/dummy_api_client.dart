import 'package:example/core/remote/api_client.dart';
import 'package:example/core/remote/model/product.dart';

class DummyApiClient {
  final String baseUrl = "https://dummyjson.com";

  late ApiClient _client;

  DummyApiClient._() {
    _client = ApiClient.create(
      baseUrl: baseUrl,
      contentType: "application/json",
    );
  }

  factory DummyApiClient.instance() => DummyApiClient._();

  Future<List<Product>> getAllProducsts({
    int page = 1,
    int pageSize = 10,
  }) async {
    final result = await _client.requestCall(
      endpoint: "/products",
      method: ApiMethod.get,
      query: {
        'skip': (page - 1) * pageSize,
        'limit': pageSize,
      },
    );
    final response = ProductsResponse.fromJson(result);
    return response.products ?? [];
  }

  Future<Product> getSingleProduct(int id) async {
    final result = await _client.requestCall(
      endpoint: "/products/$id",
      method: ApiMethod.get,
    );
    final response = Product.fromJson(result);
    return response;
  }

  Future<Product> createProduct(Map<String, dynamic> json) async {
    final result = await _client.requestCall(
      endpoint: "/products/add",
      method: ApiMethod.post,
      data: json,
    );
    final response = Product.fromJson(result);
    return response;
  }
}
