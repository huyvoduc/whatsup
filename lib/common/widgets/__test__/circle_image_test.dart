import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whatsup/common/widgets/circle_image.dart';

void main() {
  testWidgets('Dashboard', (WidgetTester tester) async {
    final widget = CircleImage(
      image: Image.asset(
        'assets/images/1.jpg',
        fit: BoxFit.cover,
        height: 50,
        width: 50,
      ),
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: widget),
    ));

    expect(find.byType(Image), findsOneWidget);
  });
}
