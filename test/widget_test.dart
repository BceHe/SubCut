// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:subcut/app.dart';
import 'package:subcut/features/settings/data/budget_repository.dart';
import 'package:subcut/features/settings/data/profile_repository.dart';

void main() {
  testWidgets('asks for a name before opening the dashboard',
      (WidgetTester tester) async {
    final repository = _MemoryProfileRepository();
    await tester.pumpWidget(
      SubCutApp(
        profileRepository: repository,
        budgetRepository: _MemoryBudgetRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Siapa nama Anda?'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), '  Budi  ');
    await tester.tap(find.text('Mulai menggunakan SubCut'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(repository.name, 'Budi');
    expect(find.text('Ringkasan'), findsOneWidget);
  });

  testWidgets('skips the name form when a name is already saved',
      (WidgetTester tester) async {
    final repository = _MemoryProfileRepository()..name = 'Budi';
    await tester.pumpWidget(
      SubCutApp(
        profileRepository: repository,
        budgetRepository: _MemoryBudgetRepository(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Ringkasan'), findsOneWidget);
    expect(find.text('Siapa nama Anda?'), findsNothing);

    await tester.tap(find.byTooltip('Profil'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Budi'), findsOneWidget);
  });

  testWidgets('shows validation when the name is blank',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      SubCutApp(
        profileRepository: _MemoryProfileRepository(),
        budgetRepository: _MemoryBudgetRepository(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mulai menggunakan SubCut'));
    await tester.pumpAndSettle();

    expect(find.text('Nama wajib diisi.'), findsOneWidget);
    expect(find.text('Ringkasan'), findsNothing);
  });
}

class _MemoryProfileRepository extends ProfileRepository {
  String? name;

  @override
  Future<String?> getName() async => name;

  @override
  Future<void> saveName(String name) async {
    this.name = name;
  }
}

class _MemoryBudgetRepository extends BudgetRepository {
  int? budget;

  @override
  Future<int?> getMonthlyBudget() async => budget;

  @override
  Future<void> saveMonthlyBudget(int amount) async {
    budget = amount;
  }

  @override
  Future<void> clearMonthlyBudget() async {
    budget = null;
  }
}
