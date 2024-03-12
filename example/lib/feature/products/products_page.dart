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
              child: StateContainer<BaseListState<Product>, Product>(
                logic: logic,
                successWidget: ScrollableListWidget(
                  prefixWidgets: const [
                    Text(
                      "Products",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  datas: logic.data,
                  padding: const EdgeInsets.all(16),
                  separator: (index) => const SizedBox(height: 16),
                  listItem: (index) => ProductListItem(
                    data: logic.data[index],
                    onPressed: (value) {
                      Navigator.of(context).pushNamed(
                        ProductDetailPage.route,
                        arguments: logic.data[index].id,
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
