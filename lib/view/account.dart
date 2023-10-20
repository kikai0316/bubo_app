import 'package:bubu_app/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({
    super.key,
  });
  // final UserData userData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final safeAreaHeight = safeHeight(context);
    // final safeAreaWidth = MediaQuery.of(context).size.width;
    // final imgList1 = useState<List<Uint8List>>([]);
    // final index = useState<int>(0);

    return const Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: blackColor,
    );
  }
}
