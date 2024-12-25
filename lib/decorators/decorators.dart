import 'package:flutter/widgets.dart';

// * Personal thoughts!
/// Extension style decorators, to keep the primary widget on the top,
/// and all styling widgets outwards to help visualization.
extension WidgetDecorators on Widget {
  /// Creates a [DecoratedBox] and wraps this as the child.
  Widget decoratedBox({
    required Decoration decoration,
    DecorationPosition position = DecorationPosition.background,
  }) {
    return DecoratedBox(
      decoration: decoration,
      position: position,
      child: this,
    );
  }

  /// Creates a [Padding] and wraps this as the child.
  Widget padding(EdgeInsetsGeometry padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }

  /// Wraps the child with a [SingleChildScrollView] when the device height
  /// is less than 640px.
  Widget wrapScrollableConditionally(double height) {
    if (height < 640) {
      return SingleChildScrollView(child: this);
    }
    return this;
  }
}
