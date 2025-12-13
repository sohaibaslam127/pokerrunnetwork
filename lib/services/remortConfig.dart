import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pokerrunnetwork/config/global.dart';

class RemoteConfigService {
  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 15),
        minimumFetchInterval: const Duration(seconds: 5),
      ),
    );
    await remoteConfig.setDefaults({
      'serviceFee': serviceFee,
      'miles': miles,
      'coriderFee': coriderFee,
      'defaultSponsor': defaultSponsor,
      'enableAds': enableAds,
      'latestAppVersion': latestAppVersion,
      'needApproval': needApproval,
      'autoFillCards': autoFillCards,
    });
    await remoteConfig.fetchAndActivate();
    serviceFee = remoteConfig.getDouble('serviceFee');
    coriderFee = remoteConfig.getDouble('coriderFee');
    defaultSponsor = remoteConfig.getString('defaultSponsor');
    miles = remoteConfig.getDouble('miles');
    enableAds = remoteConfig.getBool('enableAds');
    latestAppVersion = remoteConfig.getString('latestAppVersion');
    autoFillCards = remoteConfig.getBool('autoFillCards');
    needApproval = remoteConfig.getBool('needApproval');
  }
}
