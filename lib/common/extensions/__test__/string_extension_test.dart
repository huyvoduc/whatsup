import 'package:flutter_test/flutter_test.dart';
import '../string_extension.dart';

void main() {
  group('allWordsCapitilize', () {
    test('test words', () {
      expect('demo app'.allWordsCapitilize(), 'Demo App');
      expect('Face ID'.allWordsCapitilize(), 'Face ID');

      expect('USE PASSWORD'.allWordsCapitilizeAndtoUpperCase(), 'Use Password');
    });
  });
}
