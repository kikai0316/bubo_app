import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/firebase_options.dart';
import 'package:bubu_app/view/start_page.dart';
import 'package:bubu_app/view/user_app.dart';
import 'package:bubu_app/view_model/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? user = FirebaseAuth.instance.currentUser;
    final notifier = ref.watch(userDataNotifierProvider);
    final notifierWhen = notifier.when(
      data: (data) => user != null && data != null
          ? UserApp(
              userData: data,
            )
          : const StartPage(),
      error: (e, s) => const StartPage(),
      loading: () => const WithIconInLoadingPage(),
    );
    return MaterialApp(debugShowCheckedModeBanner: false, home: notifierWhen);
  }
}
