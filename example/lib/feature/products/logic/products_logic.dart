import 'package:example/core/remote/dummy_api_client.dart';
import 'package:example/core/remote/model/product.dart';
import 'package:flosha/base/logic/base_list_logic.dart';
import 'package:flosha/base/state/base_list_state.dart';

class ProductsLogic extends BaseListLogic<Product> {
  ProductsLogic() : super(const BaseListState());

  @override
  void onInit() {
    super.onInit();

    loadData();
  }

  @override
  void loadNextData() {
    loadData(page: state.page + 1);
  }

  @override
  void refreshData() {
    loadData();
  }

  @override
  Future<void> loadData({int page = 1}) async {
    try {
      loading();

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
