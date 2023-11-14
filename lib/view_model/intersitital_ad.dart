import 'package:bubu_app/constant/dummy_data.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'intersitital_ad.g.dart';

late InterstitialAd interstitialAd;

@Riverpod(keepAlive: true)
class InterstitialAdNotifier extends _$InterstitialAdNotifier {
  @override
  Future<InterstitialAd?> build() async {
    init();
    return null;
  }

  Future<void> init() async {
    state = const AsyncValue.loading();
    InterstitialAd.load(
      adUnitId: textADID,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) async {
          interstitialAd = ad;
          state = await AsyncValue.guard(() async {
            return interstitialAd;
          });
          // interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
          //   onAdDismissedFullScreenContent: (ad) {
          //     ad.dispose();
          //     getInstagramToNext(false);
          //   },
          //   onAdFailedToShowFullScreenContent: (ad, error) {
          //     ad.dispose();
          //   },
          // );
        },
        onAdFailedToLoad: (errror) async {
          interstitialAd.dispose();
          state = await AsyncValue.guard(() async {
            return null;
          });
        },
      ),
    );
  }

  Future<void> dispose() async {
    interstitialAd.dispose();
    state = await AsyncValue.guard(() async {
      return null;
    });
    init();
  }
}
