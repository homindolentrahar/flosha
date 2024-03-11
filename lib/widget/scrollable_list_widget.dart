import 'package:flutter/material.dart';

class ScrollableListWidget<T> extends StatelessWidget {
  /// Scroll controller
  final ScrollController? controller;

  /// Apply certain physics when scrolling at the start and end of list item
  final ScrollPhysics? physics;

  /// Padding inside the [ListView.separated()]
  final EdgeInsets? padding;

  final MainAxisAlignment mainAxisAlignment;

  final CrossAxisAlignment crossAxisAlignment;

  /// List of widgets that appear above the [ListView.separated()]
  final List<Widget> prefixWidgets;

  /// Widget to divide between [prefixWidgets] and [ListView.separated()]
  final Widget? divider;

  /// List of data that will displayed inside [ListView.separated()]
  final List<T> datas;

  /// Apply certain behavior to dismiss Keyboard when item is scrolling
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// Widget to separate between [listItem] inside of [ListView.separated()]
  /// Take [index] to indicate item's position inside of list
  final Widget Function(int index) separator;

  /// Widget to display each item of [datas] inside of [ListView.separated()]
  /// Take [index] to indicate item's position inside of list
  final Widget Function(int index) listItem;

  /// Custom widget to enable pull to refresh functionality & pagination on Scrollable widget
  /// The main reason is that pagination won't work on [ListView] when it's not parented with [SmartRefresher]
  const ScrollableListWidget({
    super.key,
    this.controller,
    this.physics,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    required this.prefixWidgets,
    this.divider,
    required this.datas,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    required this.separator,
    required this.listItem,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: physics,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            ...prefixWidgets,
            divider ?? const SizedBox(height: 16),
            ListView.separated(
              controller: controller,
              keyboardDismissBehavior: keyboardDismissBehavior,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: datas.length,
              itemBuilder: (ctx, index) => listItem(index),
              separatorBuilder: (ctx, index) => separator(index),
            ),
          ],
        ),
      ),
    );
  }
}
