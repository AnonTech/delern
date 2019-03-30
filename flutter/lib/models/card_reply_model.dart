import 'dart:core';

import 'package:delern_flutter/models/base/model.dart';
import 'package:meta/meta.dart';

class CardReplyModel implements Model {
  String uid;
  String deckKey;
  String cardKey;
  String key;
  int levelBefore;
  bool reply;
  DateTime timestamp;

  CardReplyModel(
      {@required this.uid, @required this.deckKey, @required this.cardKey})
      : assert(uid != null),
        assert(deckKey != null) {
    timestamp = DateTime.now();
  }

  @override
  String get rootPath => 'views/$uid/$deckKey/$cardKey';

  @override
  Map<String, dynamic> toMap({@required bool isNew}) => {
        '$rootPath/$key': {
          'levelBefore': 'L$levelBefore',
          'reply': reply ? 'Y' : 'N',
          'timestamp': timestamp.toUtc().millisecondsSinceEpoch,
        },
      };
}
