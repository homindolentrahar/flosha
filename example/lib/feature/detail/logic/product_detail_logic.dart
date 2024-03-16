import 'package:example/core/remote/dummy_api_client.dart';
import 'package:example/core/remote/model/product.dart';
import 'package:flosha/base/logic/base_object_logic.dart';
import 'package:flosha/base/state/base_object_state.dart';

class ProductDetailLogic extends BaseObjectLogic<Product> {
  final int? id;

  ProductDetailLogic(this.id) : super(const BaseObjectState());

  double get discountedPrice {
    final double discountedPrice = (data?.price ?? 0) -
        ((data?.price ?? 0) * ((data?.discountPercentage ?? 0) / 100));

    return discountedPrice;
  }

  @override
  Product? get deserializeFromJson =>
      cache == null ? null : Product.fromJson(cache ?? {});

  @override
  bool get loadFromCache => true;

  @override
  void refreshData() {
    loadData();
  }

  @override
  Future<void> loadData() async {
    try {
      loading();

      final result = await DummyApiClient.instance().getSingleProduct(id ?? 0);

      success(result);
    } catch (e) {
      error(errorTitle: "Something went wrong", errorMessage: e.toString());
    }
  }
}
