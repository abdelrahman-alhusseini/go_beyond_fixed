import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

export 'package:go_router/go_router.dart';

T valueOrDefault<T>(T? value, T defaultValue) => value ?? defaultValue;

bool get isAndroid => false;
bool get isiOS => false;

DateTime get getCurrentTimestamp => DateTime.now();

void safeSetState(VoidCallback callback) => callback();

class FlutterFlowModel<T extends Widget> {
  void initState(BuildContext context) {}
  void dispose() {}
}

T createModel<T extends FlutterFlowModel>(BuildContext context, T Function() builder) {
  final model = builder();
  model.initState(context);
  return model;
}

extension IterableExtension<T> on Iterable<T> {
  List<T> get toListWithoutNulls => where((e) => e != null).toList();
  T? get firstOrNull => isEmpty ? null : first;
}

extension WidgetListExtension on List<Widget> {
  List<Widget> divide(Widget divider) {
    if (length <= 1) return this;
    final items = <Widget>[];
    for (var i = 0; i < length; i++) {
      items.add(this[i]);
      if (i != length - 1) items.add(divider);
    }
    return items;
  }

  List<Widget> addToStart(Widget widget) => [widget, ...this];
  List<Widget> addToEnd(Widget widget) => [...this, widget];
}

extension StringExtension on String {
  String toCapitalization(TextCapitalization capitalization) {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}

extension GoRouterHelper on BuildContext {
  void safePop() {
    if (canPop()) {
      pop();
    }
  }
}

class TransitionInfo {
  const TransitionInfo({this.hasTransition = false, this.transitionType});
  final bool hasTransition;
  final PageTransitionType? transitionType;
}

enum PageTransitionType { fade, rightToLeft, leftToRight, topToBottom, bottomToTop }

bool responsiveVisibility({
  required BuildContext context,
  bool phone = true,
  bool tablet = true,
  bool tabletLandscape = true,
  bool desktop = true,
}) {
  return true;
}
