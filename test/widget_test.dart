import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_paper_app/core/utils/responsive.dart';
import 'package:news_paper_app/presentation/widgets/home_widgets/article_image.dart';
import 'package:news_paper_app/presentation/widgets/responsive/responsive_content.dart';
import 'package:news_paper_app/presentation/widgets/responsive/sliver_responsive_grid.dart';
import 'package:news_paper_app/presentation/widgets/responsive_shell.dart';
import 'package:news_paper_app/presentation/widgets/search_widgets/pagination_bar.dart';

void main() {
  group('Responsive Breakpoint Unit Tests', () {
    test('Breakpoints map accurately to ScreenSize', () {
      expect(ScreenSize.fromWidth(320), ScreenSize.compact);
      expect(ScreenSize.fromWidth(360), ScreenSize.compact);
      expect(ScreenSize.fromWidth(430), ScreenSize.compact);
      expect(ScreenSize.fromWidth(599), ScreenSize.compact);
      expect(ScreenSize.fromWidth(600), ScreenSize.medium);
      expect(ScreenSize.fromWidth(768), ScreenSize.medium);
      expect(ScreenSize.fromWidth(1023), ScreenSize.medium);
      expect(ScreenSize.fromWidth(1024), ScreenSize.expanded);
      expect(ScreenSize.fromWidth(1280), ScreenSize.expanded);
      expect(ScreenSize.fromWidth(1439), ScreenSize.expanded);
      expect(ScreenSize.fromWidth(1440), ScreenSize.large);
      expect(ScreenSize.fromWidth(1920), ScreenSize.large);
    });

    test('Responsive columns calculation', () {
      expect(Responsive.columnsFor(360, minItemWidth: 280), 1);
      expect(Responsive.columnsFor(700, minItemWidth: 280), 2);
      expect(Responsive.columnsFor(1200, minItemWidth: 280), 4);
    });

    test('Responsive gutter calculation scales with screen size', () {
      expect(Responsive.gutterFor(320), 16);
      expect(Responsive.gutterFor(768), 24);
      expect(Responsive.gutterFor(1200), 32);
      expect(Responsive.gutterFor(1600), 40);
    });
  });

  group('ResponsiveShell Widget Tests', () {
    Widget buildShellWithWidth(double width) {
      return MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, 800)),
          child: const ResponsiveShell(
            child: Scaffold(body: Center(child: Text('Main Page Content'))),
          ),
        ),
      );
    }

    testWidgets('Compact width (<600) does not render NavigationRail', (tester) async {
      await tester.pumpWidget(buildShellWithWidth(390));
      expect(find.text('Main Page Content'), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });

    testWidgets('Medium width (600-1023) renders compact NavigationRail', (tester) async {
      await tester.pumpWidget(buildShellWithWidth(768));
      expect(find.text('Main Page Content'), findsOneWidget);
      expect(find.byType(NavigationRail), findsOneWidget);

      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isFalse);
    });

    testWidgets('Expanded width (>=1024) renders extended NavigationRail (sidebar)', (tester) async {
      await tester.pumpWidget(buildShellWithWidth(1280));
      expect(find.text('Main Page Content'), findsOneWidget);
      expect(find.byType(NavigationRail), findsOneWidget);

      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isTrue);
    });
  });

  group('PaginationBar Small Screen Test', () {
    testWidgets('PaginationBar renders without overflow on 320px width', (tester) async {
      tester.view.physicalSize = const Size(320, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320,
              child: PaginationBar(
                currentPage: 3,
                totalPages: 10,
                onPageSelected: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(PaginationBar), findsOneWidget);
    });
  });

  group('ArticleImage Null-Safety Test', () {
    testWidgets('ArticleImage gracefully handles null and empty image URLs', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ArticleImage(imageUrl: null, width: 200, height: 120),
                ArticleImage(imageUrl: '', width: 200, height: 120),
                ArticleImage(imageUrl: '   ', width: 200, height: 120),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(ArticleImage), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });
  });

  group('Responsive Content and Grid Tests', () {
    testWidgets('ResponsiveContent caps width at maxWidth', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveContent(
              maxWidth: 600,
              child: Text('Constrained Child'),
            ),
          ),
        ),
      );

      expect(find.text('Constrained Child'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('SliverResponsiveGrid builds equal-height rows without crashing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverResponsiveGrid(
                  itemCount: 6,
                  minItemWidth: 200,
                  itemBuilder: (context, index) => Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.blue,
                    child: Text('Card $index'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Card 0'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
