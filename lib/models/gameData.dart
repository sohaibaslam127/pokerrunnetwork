import 'package:pokerrunnetwork/models/event.dart';
import 'package:pokerrunnetwork/models/gamePlayerModel.dart';

class GameData {
  late EventModel latestEvent;
  late GamePlayerModel game;
  late int gameStage;

  GameData() {
    latestEvent = EventModel();
    game = GamePlayerModel();
    gameStage = 0;
  }
}
