import 'package:flutter/material.dart';

class StateWidgetConfig {
  /// [title] that will displayed in the state container display
  final String? title;

  /// [message] that will displayed in the state container display
  final String? message;

  /// Textstyle for [title]
  final TextStyle? titleStyle;

  /// Textstyle for [message]
  final TextStyle? messageStyle;

  /// Custom widget to replace default state container display
  final Widget? widget;

  /// Custom image to replace default state container display - icon
  final ImageProvider? image;

  /// Config class to handle properties that will displayed on widget with a certain state
  StateWidgetConfig({
    this.title,
    this.message,
    this.titleStyle,
    this.messageStyle,
    this.widget,
    this.image,
  });
}

class StateFormSubmitButtonConfig {
  /// Spacing from Form fields to Submit button
  final double spaceFromFields;

  // Text to display in Submit button
  final String buttonText;

  /// Style for default Submit button
  final ButtonStyle? buttonStyle;

  /// Widget that will override default Submit button
  final Widget? buttonWidget;

  /// Wether to show default submit button
  final bool showDefaultSubmitButton;

  StateFormSubmitButtonConfig({
    this.spaceFromFields = 32,
    required this.buttonText,
    required this.buttonStyle,
    required this.buttonWidget,
    this.showDefaultSubmitButton = true,
  });
}
