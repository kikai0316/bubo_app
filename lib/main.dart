import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/firebase_options.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/path_provider_utility.dart';
import 'package:bubu_app/view/login.dart';
import 'package:bubu_app/view/user_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? user = FirebaseAuth.instance.currentUser;
    Future<UserData?> getSecureStorageData() async {
      await cacheSecureStorage();
      final UserData? userData = await readUserData();
      return userData;
    }

    if (user == null) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StartPage(),
      );
    } else {
      return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<UserData?>(
          future: getSecureStorageData(),
          builder: (BuildContext context, AsyncSnapshot<UserData?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const WithIconInLoadingPage();
            } else if (snapshot.hasError) {
              return const StartPage();
            } else {
              if (snapshot.data == null) {
                return const StartPage();
              } else {
                return const UserApp(initPage: 0);
              }
            }
          },
        ),
      );
    }
  }
}

Future<void> cacheSecureStorage() async {
  final prefs = await SharedPreferences.getInstance();
  final isFirst = prefs.getBool('is_first');
  if (isFirst == null || isFirst) {
    // flutter_secure_storageのデータを破棄
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
    await prefs.setBool('is_first', false);
  }
}
