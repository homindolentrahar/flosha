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
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(CreateProductPage.route);
              },
            ),
            body: SafeArea(
              child: StateContainer<BaseListState<Product>, Product>(
                logic: builderCtx.watch<ProductsLogic>(),
                successWidget: (state) => ScrollableListWidget(
                  prefixWidgets: const [
                    Text(
                      "Products",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  datas: state.list ?? [],
                  padding: const EdgeInsets.all(16),
                  separator: (index) => const SizedBox(height: 16),
                  listItem: (index) => ProductListItem(
                    data: state.list?[index],
                    onPressed: (value) {
                      Navigator.of(context).pushNamed(
                        ProductDetailPage.route,
                        arguments: state.list?[index].id,
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
