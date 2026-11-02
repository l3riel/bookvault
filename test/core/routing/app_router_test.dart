import 'package:bookvault/app/app.dart';
import 'package:bookvault/app/app_dependencies.dart';
import 'package:bookvault/core/network/dio_client.dart';
import 'package:bookvault/core/routing/app_router.dart';
import 'package:bookvault/core/routing/app_routes.dart';
import 'package:bookvault/features/book_details/presentation/book_details_page.dart';
import 'package:bookvault/features/explore/presentation/explore_page.dart';
import 'package:bookvault/features/home/presentation/home_page.dart';
import 'package:bookvault/features/library/presentation/library_page.dart';
import 'package:bookvault/features/onboarding/presentation/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<GoRouter> pumpApp(WidgetTester tester, {bool onboarded = true}) async {
    final dependencies = AppDependencies(
      preferences: await SharedPreferences.getInstance(),
      dio: createDioClient(),
    );
    final router = createAppRouter(isOnboarded: () => onboarded);
    await tester.pumpWidget(
      BookVaultApp(dependencies: dependencies, router: router),
    );
    await tester.pumpAndSettle();
    return router;
  }

  int selectedTab(WidgetTester tester) =>
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex;

  testWidgets('abre no Início com as três abas', (tester) async {
    await pumpApp(tester);

    expect(find.byType(HomePage), findsOneWidget);
    final bar = find.byType(NavigationBar);
    for (final label in ['Início', 'Explorar', 'Biblioteca']) {
      expect(
        find.descendant(of: bar, matching: find.text(label)),
        findsOneWidget,
      );
    }
    expect(selectedTab(tester), 0);
  });

  testWidgets('troca de aba pela barra inferior', (tester) async {
    await pumpApp(tester);
    final bar = find.byType(NavigationBar);

    await tester.tap(find.descendant(of: bar, matching: find.text('Explorar')));
    await tester.pumpAndSettle();
    expect(find.byType(ExplorePage), findsOneWidget);
    expect(selectedTab(tester), 1);

    await tester.tap(
      find.descendant(of: bar, matching: find.text('Biblioteca')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(LibraryPage), findsOneWidget);
    expect(selectedTab(tester), 2);
  });

  testWidgets('sem onboarding, redireciona para o onboarding', (tester) async {
    await pumpApp(tester, onboarded: false);

    expect(find.byType(OnboardingPage), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('abre os detalhes pelo id do livro', (tester) async {
    final router = await pumpApp(tester);

    router.go(AppRoutes.bookDetailsOf('zyTCAlFPjgYC'));
    await tester.pumpAndSettle();

    expect(find.byType(BookDetailsPage), findsOneWidget);
    expect(find.text('zyTCAlFPjgYC'), findsOneWidget);
  });
}
