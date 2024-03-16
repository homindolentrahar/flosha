# Flosha

Boilerplate for handling state with BLoC/Cubit pattern in a smooth way

## Features

- [x] Easy state-handling
- [x] Bult-in state-handling widget
- [x] Form state-handling support
- [x] Pull to Refresh support
- [x] Pagination support
- [x] State changes logging
- [x] Cubit wrapper
- [ ] Bloc wrapper
- [x] Local cache support

## Get Started

To install `flosha`, add these following codes into your `pubspec.yaml` file:

```yaml
dependencies:
  ...
  flosha: ^1.1.0
```

## The Logics

### BaseObjectLogic

`BaseObjectLogic` is a class that handle business logic and state manipulation with data type of `T`. It's like a 'controller' class that have several functions to load data from data source and handle pull-to-refresh functionality.

It has 4 functions to manipulate state:

- `loading()`\
  To invoke a loading state
- `empty()`\
  To invoke an empty state. It will set `data` field inside state to `[]` or empty list. Will display default empty widget if you use `StateContainer` or `StateConsumer`.
- `success(data)`\
  To invoke a success state. It takes only `data` as parameters, whereas `data` is an object/data loaded from data source and will be populated to the UI.
- `error(errorTitle, errorMessage)`\
  To invoke an error state. It takes two parameters, `errorTitle` is a title you want to display on the default error widget; and `errorMessage` is a message you want to display on the default error widget.

```dart
class ProductDetailLogic extends BaseObjectLogic<Product> {
  final int? id;

  ProductDetailLogic(this.id) : super(const BaseObjectState());

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
```

### BaseListLogic

`BaseListLogic` is a class that handle business logic and state manipulation with data type of `List<T>`. It's like a 'controller' class that have several functions to load data from data source, handle pull-to-refresh functionality, and pagination.

It has 4 functions to manipulate state:

- `loading()`\
  To invoke a loading state
- `empty()`\
  To invoke an empty state. It will set `data` field inside state to `[]` or empty list. Will display default empty widget if you use `StateContainer` or `StateConsumer`.
- `success(data, page)`\
  To invoke a success state. It takes two parameters, `data` is a list of data loaded from data source and will be populated to the UI; and `page` to indicate current position of these set of data on pagination manners.
- `error(errorTitle, errorMessage)`\
  To invoke an error state. It takes two parameters, `errorTitle` is a title you want to display on the default error widget; and `errorMessage` is a message you want to display on the default error widget.

```dart
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
```

### BaseFormLogic

`BaseObjectLogic` is a class that handle business logic and state manipulation with data type of `T`. It's like a 'controller' class that have several functions to load data from data source and handle pull-to-refresh functionality.

It has 3 functions to manipulate state:

- `loading()`\
  To invoke a loading state
- `success(data)`\
  To invoke a success state. It takes only `data` as parameters, whereas `data` is an object/data loaded from data source and will be populated to the UI.
- `error(errorTitle, errorMessage)`\
  To invoke an error state. It takes two parameters, `errorTitle` is a title you want to display on the default error widget; and `errorMessage` is a message you want to display on the default error widget.

Also, the `dataType` getter defines the data type of the response, wether it's `List<T>` or just an object of `T`.

```dart
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

          success(data: result);
        });
      } catch (e) {
        log("Error: ${e.toString()}");
        error(errorTitle: "Something went wrong", errorMessage: e.toString());
      }
    }
  }
}
```

## The Widgets

> 💡 Dont forget to Wrap these widget within `BlocProvider` and `Builder` at the top of widget tree

```dart
return BlocProvider(
    create: (_) => ProductsLogic(),
    child: Builder(
        builder: (builderCtx) {
            final logic = builderCtx.read<ProductsLogic>();

            return Scaffold(
                floatingActionButton: FloatingActionButton(
                    child: const Icon(Icons.add),onPressed: () {
                        Navigator.of(context).pushNamed(CreateProductPage.route);
                    },
                ),
                body: SafeArea(
                    child: StateContainer<BaseListState<Product>, Product>(
                        logic: logic,
                        successWidget: (state) => SuccessWidget(),
                    ),
                ),
            );
        },
      ),
    );
```

### StateContainer

`StateContainer` is a Widget that handle state changes and rebuilding UI based on certain state. It provides default UI for loading, empty, and error state, while you have to provide a Widget that will displayed when state is success by yourself.

```dart
// To handle List data type
StateContainer<BaseListState<Product>, Product>(
    // Logic class that manage state and business logic
    logic: logic,
    successWidget: (state) => SuccessWidget(),
)
```

or

```dart
// To handle Object data type
StateContainer<BaseObjectState<Product>, Product>(
    // Logic class that manage state and business logic
    logic: logic,
    successWidget: (state) => SuccessWidget(),
)
```

### StateListener

`StateListener` is a Widget that provides a listener, which reacts on state changes. It's use `BlocListener` to listen state changes, and then do something, such as showing loading overlay or Snackbar to inform user about the process.

```dart
StateLiestener<ProductsLogic, BaseListState<Product>, Product>(
    // Logic class that manage state and business logic
    logic: logic,
    child: child,
    onListen: (result) {},
)
```

### StateConsumer

`StateConsumer` is combination between `StateContainer` and `StateListener`, which rebuild UI and execute block of code in every state changes. It combines `BlocListener` alongside `BlocBuilder` to handle state changes.

```dart
StateConsumer<ProductsLogic, BaseListState<Product>, Product>(
    logic: logic,
    onListen: (result) {
        // Execute code when the state changes
    }
    successWidget: (state) => SuccessWidget(),
)
```

### StateForm

`StateForm` is a Widget that handle state changes and reflecting it in the UI when using Forms. It's mainly use `BlocListener` to listen the state changes and then do something, such as showing loading overlay or Snackbar to inform user about the Form submission's status.

```dart
StateForm(
    logic: logic,
    onLoading: () {
        // Do something when state is loading
        // Show loading overlay, for example
    },
    onListen: (result) {
        // Do something when any state is changed (except loading). Show Snackbar, for example
        // Result has type of Either<L, R>, which you can use fold() to handle the error and success data
    },
    onSubmit: () {
        // Do something when form is submitted
        // Triggered when default Submit button is pressed
    },
    child: SomeeWidget(),
)
```

### ScrollableListWidget

`ScrollableListWidget` is a custom Widget that provide work-around to use pagination on a list with some additional widget. This widget simplify the use of `SmartRefresher` as the direct parent of `ListView` widget or other Scrollable widget.

```dart
StateContainer<BaseListState<Product>, Product>(
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
)
```
