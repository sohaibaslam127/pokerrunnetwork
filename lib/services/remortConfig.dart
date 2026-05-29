import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pokerrunnetwork/config/global.dart';

class RemoteConfigService {
  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 15),
        minimumFetchInterval: const Duration(hours: 12),
      ),
    );

    await remoteConfig.setDefaults({
      'serviceFee': serviceFee,
      'miles': miles,
      'enableAds': enableAds,
      'latestAppVersion': latestAppVersion,
      'needApproval': needApproval,
      'autoFillCards': autoFillCards,
    });

    try {
      await remoteConfig.fetchAndActivate();
    } catch (_) {
      return;
    }

    serviceFee = remoteConfig.getDouble('serviceFee');
    miles = remoteConfig.getDouble('miles');
    enableAds = remoteConfig.getBool('enableAds');
    latestAppVersion = remoteConfig.getString('latestAppVersion');
    autoFillCards = remoteConfig.getBool('autoFillCards');
    needApproval = remoteConfig.getBool('needApproval');
  }
}
