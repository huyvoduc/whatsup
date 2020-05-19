import 'package:flutter_test/flutter_test.dart';

import '../datetime_extension.dart';

void main() {
  group('datetime extention', () {
    test(' toBirthDayString', () {
      expect(DateTime(2017, 9, 7, 17, 30).toBirthDayString(), '07/09/2017');
    });
  });
}
