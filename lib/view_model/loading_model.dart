import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loading_model.g.dart';

@Riverpod(keepAlive: true)
class LoadingNotifier extends _$LoadingNotifier {
  @override
  Widget? build() {
    return null;
  }

  // ignore: use_setters_to_change_properties
  void upData(Widget? newData) {
    state = newData;
  }
}
