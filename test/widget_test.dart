import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kids/bottomnavigation.dart';

void main() {
  testWidgets('BottomNav renders 3 tabs with Home selected by default',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: BottomNav()));
    await tester.pump();

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Setting'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Privacy'), findsOneWidget);

    final bar = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(bar.currentIndex, 1);
  });
}
