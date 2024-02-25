import 'dart:developer';

import 'package:example/core/remote/dummy_api_client.dart';
import 'package:example/core/remote/model/product.dart';
import 'package:flosha/base/state/base_form_state.dart';
import 'package:flosha/flosha.dart';

class CreateProductLogic extends BaseFormLogic<Product> {
  CreateProductLogic() : super(const BaseFormState());

  @override
  BaseLogicDataType get dataType => BaseLogicDataType.object;

  Future<void> createProduct() async {
    if (saveAndValidateForm) {
      try {
        loading();

        Future.delayed(const Duration(seconds: 2), () async {
          final result = await DummyApiClient.instance().createProduct(values);

          log("Result: ${result.toJson()}");

          error(errorTitle: "Error euy", errorMessage: "Error");
        });
      } catch (e) {
        log("Error: ${e.toString()}");
        error(errorTitle: "Something went wrong", errorMessage: e.toString());
      }
    }
  }
}
