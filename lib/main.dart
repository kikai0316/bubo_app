import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/firebase_options.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/notification_utility.dart';
import 'package:bubu_app/utility/path_provider_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/login.dart';
import 'package:bubu_app/view/request_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "bobo-app",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();
  NotificationClass().initializeNotification();
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
          builder:
              (BuildContext context, AsyncSnapshot<UserData?> snapshotUser) {
            if (snapshotUser.connectionState == ConnectionState.waiting) {
              return const WithIconInLoadingPage();
            } else if (snapshotUser.hasError) {
              return const StartPage();
            } else {
              if (snapshotUser.data == null) {
                return const StartPage();
              } else {
                return FutureBuilder<bool>(
                  future: hasNotificationPermission(),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return nextScreenWhisUserDataCheck(snapshotUser.data!);
                    } else if (snapshot.hasError) {
                      return loadinPage(
                        context: context,
                        isLoading: true,
                        text: null,
                      );
                    } else {
                      if (snapshot.data == false) {
                        return RequestNotificationsPage(
                          userData: snapshotUser.data!,
                        );
                      } else {
                        return nextScreenWhisUserDataCheck(snapshotUser.data!);
                      }
                    }
                  },
                );
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

Future<bool> hasNotificationPermission() async {
  final status = await Permission.notification.status;
  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    return false;
  } else if (status.isPermanentlyDenied) {
    return true;
  }
  return false;
}
