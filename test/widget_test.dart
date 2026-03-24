import 'package:flutter_test/flutter_test.dart';
import 'package:pdf_viewer/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PdfViewerApp());
    expect(find.text('PDF Viewer'), findsOneWidget);
  });
}
