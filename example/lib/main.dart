import 'package:example/feature/create/create_product_page.dart';
import 'package:example/feature/detail/product_detail_page.dart';
import 'package:example/feature/products/products_page.dart';
import 'package:flosha/flosha.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Bloc.observer = BaseStateObserver();

    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/",
      routes: {
        ProductsPage.route: (_) => const ProductsPage(),
        ProductDetailPage.route: (_) => const ProductDetailPage(),
        CreateProductPage.route: (_) => const CreateProductPage(),
      },
      builder: EasyLoading.init(),
    );
  }
}
