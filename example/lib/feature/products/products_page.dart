import 'package:example/core/remote/model/product.dart';
import 'package:example/feature/create/create_product_page.dart';
import 'package:example/feature/detail/product_detail_page.dart';
import 'package:example/feature/products/logic/products_logic.dart';
import 'package:example/feature/products/widget/product_list_item.dart';
import 'package:flosha/base/state/base_list_state.dart';
import 'package:flosha/flosha.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  static const String route = "/";

  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductsLogic(),
      child: Builder(
        builder: (builderCtx) {
          final logic = builderCtx.read<ProductsLogic>();

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(CreateProductPage.route);
              },
            ),
            body: SafeArea(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: StateContainer<ProductsLogic, BaseListState<Product>,
                    List<Product>>(
                  logic: logic,
                  onSuccess: (data) {
                    return SmartRefresher(
                      controller: logic.refreshController,
                      onRefresh: logic.refreshData,
                      onLoading: logic.loadNextData,
                      enablePullDown: true,
                      enablePullUp: logic.state.hasMoreData,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: data?.length ?? 0,
                        separatorBuilder: (ctx, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (ctx, index) => ProductListItem(
                          data: data?[index],
                          onPressed: (value) {
                            Navigator.of(context).pushNamed(
                              ProductDetailPage.route,
                              arguments: data?[index].id,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
