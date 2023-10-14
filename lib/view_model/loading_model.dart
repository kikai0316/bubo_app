import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loading_model.g.dart';

@Riverpod(keepAlive: false)
class LoadingNotifier extends _$LoadingNotifier {
  @override
  bool build() {
    return false;
  }

  void upDateTrue() {
    state = true;
  }

  void upDateFalse() {
    state = false;
  }
}
