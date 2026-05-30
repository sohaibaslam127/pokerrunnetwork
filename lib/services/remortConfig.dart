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
      'serviceFee': serviceFee,
      'miles': miles,
      'enableAds': enableAds,
      'appVersionPlayer': appVersionPlayer,
      'needApproval': needApproval,
      'defaultSponsor': defaultSponsor,
    });

    try {
      await remoteConfig.fetchAndActivate();
    } catch (_) {
      return;
    }

    serviceFee = remoteConfig.getDouble('serviceFee');
    miles = remoteConfig.getDouble('miles');
    defaultSponsor = remoteConfig.getString('defaultSponsor');
    enableAds = remoteConfig.getBool('enableAds');
    appVersionPlayer = remoteConfig.getString('appVersionPlayer');
    needApproval = remoteConfig.getBool('needApproval');
  }
}
