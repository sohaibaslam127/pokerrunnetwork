import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pokerrunnetwork/config/global.dart';

class RemoteConfigService {
  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 15),
        minimumFetchInterval: const Duration(seconds: 15),
      ),
    );

    await remoteConfig.setDefaults({
      'enableAds': enableAds,
      'appVersionNetwork': appVersionNetwork,
      'needApproval': needApproval,
      'autoFillCards': autoFillCards,
    });

    try {
      await remoteConfig.fetchAndActivate();
    } catch (_) {
      return;
    }

    enableAds = remoteConfig.getBool('enableAds');
    appVersionNetwork = remoteConfig.getString('appVersionNetwork');
    needApproval = remoteConfig.getBool('needApproval');
    autoFillCards = remoteConfig.getBool('autoFillCards');
  }
}
