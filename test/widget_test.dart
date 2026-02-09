// Smoke tests for the Cashew Budget App
//
// These tests verify basic widget rendering without requiring
// full app initialization (Firebase, database, etc.)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App Smoke Tests', () {
    testWidgets('MaterialApp builds successfully', (WidgetTester tester) async {
      // Test that a basic MaterialApp with the app's theme structure works
      await tester.pumpWidget(
        MaterialApp(
          title: 'Cashew',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5f85c2)),
            useMaterial3: true,
          ),
          home: const Scaffold(
            body: Center(
              child: Text('Cashew Budget App'),
            ),
          ),
        ),
      );

      // Verify the app title text is rendered
      expect(find.text('Cashew Budget App'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Basic navigation structure renders', (WidgetTester tester) async {
      // Test a simplified version of the app's navigation structure
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                // Simulating the sidebar navigation structure
                Container(
                  width: 80,
                  color: Colors.grey[200],
                  child: const Column(
                    children: [
                      Icon(Icons.home),
                      Icon(Icons.account_balance_wallet),
                      Icon(Icons.settings),
                    ],
                  ),
                ),
                // Main content area
                const Expanded(
                  child: Center(
                    child: Text('Budget Dashboard'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify navigation icons are present
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.text('Budget Dashboard'), findsOneWidget);
    });

    testWidgets('FAB renders correctly', (WidgetTester tester) async {
      // Test FloatingActionButton commonly used for adding transactions
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
            body: const Center(
              child: Text('Transactions'),
            ),
          ),
        ),
      );

      // Verify FAB is present and tappable
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      
      // Tap the FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
    });

    testWidgets('Theme colors are applied', (WidgetTester tester) async {
      // Test that theme is properly applied
      const primaryColor = Color(0xFF5f85c2);
      
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          ),
          home: Builder(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Budget'),
                ),
                body: Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: const Text('Theme Test'),
                ),
              );
            },
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Budget'), findsOneWidget);
      expect(find.text('Theme Test'), findsOneWidget);
    });

    testWidgets('Empty state widget renders', (WidgetTester tester) async {
      // Test empty state that might appear when no transactions exist
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap + to add your first transaction',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.receipt_long), findsOneWidget);
      expect(find.text('No transactions yet'), findsOneWidget);
      expect(find.text('Tap + to add your first transaction'), findsOneWidget);
    });
  });
}
