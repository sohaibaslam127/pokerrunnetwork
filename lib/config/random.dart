import 'dart:math';

class NRandom {
  NRandom(
    this._length, [
    this._decreaseFactor = 5,
    List<double>? probabilities,
  ]) {
    if (_length > 0) {
      final double probability = 100 / _length;
      if (probabilities == null) {
        this.probabilities = List<double>.filled(_length, probability);
      } else {
        this.probabilities = probabilities;
      }
    } else {
      throw ArgumentError('length must > 0');
    }
  }

  int _length = 0;
  int _decreaseFactor = 5;
  List<double>? probabilities;

  void init(int length, [int decreaseFactor = 5, List<double>? probabilities]) {
    if (length > 0) {
      _length = length;
      _decreaseFactor = decreaseFactor;
      final double probability = 100 / _length;
      if (probabilities == null) {
        this.probabilities = List<double>.filled(_length, probability);
      } else {
        this.probabilities = probabilities;
      }
    } else {
      throw ArgumentError('length must > 0');
    }
  }

  int getNextIndex() {
    if (_length == 0) {
      return -1;
    } else if (_length == 1) {
      return 0;
    }

    final double r = Random().nextDouble();

    double s = 0;
    int index = 0;
    for (int i = 0; i < _length; i++) {
      final double p = probabilities![i] / 100;
      if (r >= s && r < (s + p)) {
        index = i;
        break;
      }
      s += p;
    }

    final double x = _decreaseFactor == 0
        ? 0
        : (probabilities![index] / _decreaseFactor);

    final double y = (probabilities![index] - x) / (_length - 1);
    for (int i = 0; i < _length; i++) {
      if (i == index) {
        probabilities![i] = x;
      } else {
        probabilities![i] += y;
      }
    }
    return index;
  }
}
