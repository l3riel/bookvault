import 'package:bookvault/app/theme/app_theme.dart';
import 'package:bookvault/app/widgets/book_cover.dart';
import 'package:bookvault/app/widgets/status_badge.dart';
import 'package:bookvault/models/reading_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: Center(child: SizedBox(width: 120, height: 180, child: child)),
        ),
      ),
    );
  }

  testWidgets('capa sem URL mostra marcador com o título', (tester) async {
    await pump(tester, const BookCover(title: 'Duna'));

    expect(
      find.byKey(const ValueKey('book-cover-placeholder')),
      findsOneWidget,
    );
    expect(find.text('Duna'), findsOneWidget);
  });

  testWidgets('capa que falha ao carregar mostra o marcador', (tester) async {
    await pump(
      tester,
      const BookCover(
        title: 'Duna',
        imageUrl: 'https://exemplo.invalido/c.jpg',
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('book-cover-placeholder')),
      findsOneWidget,
    );
  });

  testWidgets('selo mostra o rótulo do status', (tester) async {
    for (final status in ReadingStatus.values) {
      await pump(tester, StatusBadge(status: status));
      expect(find.text(status.label), findsOneWidget);
    }
  });
}
