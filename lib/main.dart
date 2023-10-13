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
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    Future<UserData?> getSecureStorageData() async {
      await cacheSecureStorage();
      final UserData? userData = await readUserData();
      if (userData != null && user != null) {
        return userData;
      } else {
        return null;
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<UserData?>(
        future: getSecureStorageData(),
        builder: (BuildContext context, AsyncSnapshot<UserData?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const WithIconInLoadingPage();
          }
          if (snapshot.hasError) {
            return const LoginPage();
          }
          if (snapshot.data != null) {
            return UserApp(
              userData: snapshot.data!,
            );
          }
          return const LoginPage();
        },
      ),
    );
  }
}

//初起動だったらflutter_secure_storage（Keychain）の中身を消す
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
