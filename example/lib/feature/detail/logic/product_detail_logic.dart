import 'package:example/core/remote/dummy_api_client.dart';
import 'package:example/core/remote/model/product.dart';
import 'package:flosha/base/logic/base_object_logic.dart';
import 'package:flosha/base/state/base_object_state.dart';

class ProductDetailLogic extends BaseObjectLogic<Product> {
  final int? id;

  ProductDetailLogic(this.id) : super(const BaseObjectState());

  @override
  void onInit() {
    super.onInit();

    loadData();
  }

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
