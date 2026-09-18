import 'package:flutter_test/flutter_test.dart';
import 'package:diginote/main.dart';

void main() {
  testWidgets('DigiNote app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('DIGINOTE'), findsOneWidget);
  });
}