import 'package:example/core/remote/dummy_api_client.dart';
import 'package:example/core/remote/model/product.dart';
import 'package:flosha/base/logic/base_list_logic.dart';
import 'package:flosha/base/state/base_list_state.dart';

class ProductsLogic extends BaseListLogic<Product> {
  ProductsLogic() : super(const BaseListState());

  @override
  List<Product> get deserializeFromJson =>
      cache.map((e) => Product.fromJson(e)).toList();

  @override
  bool get loadFromCache => true;

  @override
  void loadNextData() {
    loadData(page: state.page + 1);
  }

  @override
  void refreshData() {
    loadData(initialLoad: true);
  }

  @override
  Future<void> loadData({int page = 1, bool initialLoad = false}) async {
    try {
      loading(initialLoad: initialLoad);

      final result = await DummyApiClient.instance().getAllProducsts(
        page: page,
        pageSize: pageSize,
      );

      success(data: result, page: page);
    } catch (e) {
      error(errorTitle: "Error occured", errorMessage: e.toString());
    }
  }
}
