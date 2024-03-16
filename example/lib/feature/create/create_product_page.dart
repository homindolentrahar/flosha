import 'dart:developer';

import 'package:example/feature/create/logic/create_product_logic.dart';
import 'package:flosha/flosha.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CreateProductPage extends StatelessWidget {
  static const String route = "/crate";

  const CreateProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateProductLogic(),
      child: Builder(builder: (builderCtx) {
        final logic = builderCtx.read<CreateProductLogic>();

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Create  Product",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: StateForm(
                logic: logic,
                onLoading: () {
                  EasyLoading.show(status: "Creating product...");
                },
                onListen: (result) {
                  EasyLoading.dismiss();

                  result.fold(
                    (error) {
                      log("${error.title}: ${error.message}");
                      EasyLoading.showError("${error.title}: ${error.message}");
                    },
                    (data) {
                      EasyLoading.showSuccess("Success creating project");

                      // Navigator.pop(context);
                    },
                  );
                },
                onSubmit: () {
                  logic.createProduct();
                },
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'title',
                      decoration: const InputDecoration(hintText: "Title"),
                      validator: FormBuilderValidators.required(),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'description',
                      decoration:
                          const InputDecoration(hintText: "Description"),
                      maxLines: 3,
                      minLines: 3,
                      validator: FormBuilderValidators.required(),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'price',
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: "Price"),
                      validator: FormBuilderValidators.required(),
                      valueTransformer: (value) => int.tryParse(value ?? "0"),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'stock',
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: "Stock"),
                      validator: FormBuilderValidators.required(),
                      valueTransformer: (value) => int.tryParse(value ?? "0"),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'brand',
                      decoration: const InputDecoration(hintText: "Brand"),
                      validator: FormBuilderValidators.required(),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'category',
                      decoration: const InputDecoration(hintText: "Category"),
                      validator: FormBuilderValidators.required(),
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
