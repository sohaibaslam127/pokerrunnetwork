class HandResult {
  final int score;
  final String rank;

  HandResult(this.score, this.rank);

  @override
  String toString() => "$rank (score=$score)";
}

class Analysis {
  String faceName(int idx) {
    const names = [
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine',
      'ten',
      'jack',
      'queen',
      'king',
      'ace',
    ];
    return names[idx];
  }

  int _faceIndexFromItem(int item) {
    final r = item % 13;
    switch (r) {
      case 0:
        return 9;
      case 1:
        return 12;
      case 2:
        return 0;
      case 3:
        return 1;
      case 4:
        return 2;
      case 5:
        return 3;
      case 6:
        return 4;
      case 7:
        return 5;
      case 8:
        return 6;
      case 9:
        return 7;
      case 10:
        return 8;
      case 11:
        return 11;
      case 12:
        return 10;
    }
    return -1;
  }

  int _suitIndexFromItem(int item) {
    if (item < 0 || item > 51) return -1;
    if (item <= 12) return 1;
    if (item <= 25) return 3;
    if (item <= 38) return 2;
    return 0;
  }

  int _encodeScore(int category, List<int> tiebreak) {
    final tb = List<int>.from(tiebreak);
    while (tb.length < 5) {
      tb.add(0);
    }

    int s = (category & 0xF) << 30;
    for (int i = 0; i < 5; i++) {
      s |= ((tb[i] & 0x1F) << (25 - (i * 5)));
    }
    return s;
  }

  HandResult converter(List<int> listOfCard) {
    if (listOfCard.length != 5 || listOfCard.any((c) => c < 0 || c > 51)) {
      return HandResult(0, 'invalid');
    }

    final faces = <int>[];
    final suits = <int>[];
    for (final item in listOfCard) {
      faces.add(_faceIndexFromItem(item));
      suits.add(_suitIndexFromItem(item));
    }
    if (suits.any((s) => s == -1)) return HandResult(0, 'invalid');

    final flush = suits.every((s) => s == suits[0]);

    final counts = <int, int>{};
    for (final f in faces) {
      counts[f] = (counts[f] ?? 0) + 1;
    }

    final groupSizes = counts.values.toList()..sort((b, a) => a.compareTo(b));

    final uniq = counts.keys.toList()..sort();
    bool straight = false;
    int highStraight = -1;
    if (uniq.length == 5 && (uniq.last - uniq.first == 4)) {
      straight = true;
      highStraight = uniq.last;
    }
    if (!straight &&
        uniq.contains(12) &&
        uniq.contains(0) &&
        uniq.contains(1) &&
        uniq.contains(2) &&
        uniq.contains(3)) {
      straight = true;
      highStraight = 3;
    }

    int category = 0;
    List<int> tiebreak = [];
    String desc = "";

    if (straight && flush) {
      if (highStraight == 12) {
        category = 9;
        tiebreak = [12];
        desc = "Royal flush";
      } else {
        category = 8;
        tiebreak = [highStraight];
        desc = "Straight flush to the ${faceName(highStraight)}";
      }
    } else if (groupSizes[0] == 4) {
      final quad = counts.keys.firstWhere((k) => counts[k] == 4);
      final kicker = counts.keys.firstWhere((k) => counts[k] == 1);
      category = 7;
      tiebreak = [quad, kicker];
      // desc = "four of a kind: ${faceName(quad)}s — kicker: ${faceName(kicker)}";
      desc = "Four of a kind: ${faceName(quad)}s";
    } else if (groupSizes[0] == 3 && groupSizes[1] == 2) {
      final three = counts.keys.firstWhere((k) => counts[k] == 3);
      final pair = counts.keys.firstWhere((k) => counts[k] == 2);
      category = 6;
      tiebreak = [three, pair];
      // desc = "full house: ${faceName(three)}s over ${faceName(pair)}s";
      desc = "Full house: ${faceName(three)}s";
    } else if (flush) {
      final sortedFaces = [...faces]..sort((b, a) => a.compareTo(b));
      category = 5;
      tiebreak = sortedFaces;
      // desc = "flush, ${faceName(sortedFaces.first)} high — kickers: ${_facesToKickerText(sortedFaces)}";
      desc = "Flush, ${faceName(sortedFaces.first)} high";
    } else if (straight) {
      category = 4;
      tiebreak = [highStraight];
      desc = (highStraight == 12)
          ? "Ace-high straight"
          : "Straight to the ${faceName(highStraight)}";
    } else if (groupSizes[0] == 3) {
      final three = counts.keys.firstWhere((k) => counts[k] == 3);
      final kickers = counts.keys.where((k) => k != three).toList()
        ..sort((b, a) => a.compareTo(b));
      category = 3;
      tiebreak = [three, ...kickers];
      // desc = "three of a kind: ${faceName(three)}s — kickers: ${_facesToKickerText(kickers)}";
      desc = "Three of a kind: ${faceName(three)}s";
    } else if (groupSizes[0] == 2 && groupSizes[1] == 2) {
      final pairs = counts.keys.where((k) => counts[k] == 2).toList()
        ..sort((b, a) => a.compareTo(b)); // high pair first
      final kicker = counts.keys.firstWhere((k) => counts[k] == 1);
      category = 2;
      tiebreak = [pairs[0], pairs[1], kicker];
      // desc = "two pairs: ${faceName(pairs[0])}s and ${faceName(pairs[1])}s — kicker: ${faceName(kicker)}";
      desc = "Two pairs: ${faceName(pairs[0])}s and ${faceName(pairs[1])}s";
    } else if (groupSizes[0] == 2) {
      final pair = counts.keys.firstWhere((k) => counts[k] == 2);
      final kickers = counts.keys.where((k) => k != pair).toList()
        ..sort((b, a) => a.compareTo(b));
      category = 1;
      tiebreak = [pair, ...kickers]; // [pair, k1, k2, k3]
      // desc = "one pair of ${faceName(pair)}s — kickers: ${_facesToKickerText(kickers)}";
      desc = "One pair of ${faceName(pair)}s";
    } else {
      final sortedFaces = [...faces]..sort((b, a) => a.compareTo(b));
      category = 0;
      tiebreak = sortedFaces;
      // desc = "high card ${faceName(sortedFaces.first)} — kickers: ${_facesToKickerText(sortedFaces)}";
      desc = "High card ${faceName(sortedFaces.first)}";
    }

    final score = _encodeScore(category, tiebreak);
    return HandResult(score, desc);
  }
}
