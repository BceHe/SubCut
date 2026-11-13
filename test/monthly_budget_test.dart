import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subcut/features/dashboard/widgets/monthly_budget_card.dart';
import 'package:subcut/features/settings/data/budget_repository.dart';
import 'package:subcut/features/settings/domain/budget_rules.dart';
import 'package:subcut/features/settings/presentation/monthly_budget_settings.dart';

void main() {
  group('BudgetRules', () {
    test('validates positive budget amounts', () {
      expect(BudgetRules.validateBudgetInput(''), isNotNull);
      expect(BudgetRules.validateBudgetInput('0'), isNotNull);
      expect(BudgetRules.validateBudgetInput('10x'), isNotNull);
      expect(BudgetRules.validateBudgetInput('1500000'), isNull);
      expect(BudgetRules.parseBudget('1.500.000'), 1500000);
    });

    test('calculates remaining, warning, and exceeded states', () {
      final underLimit =
          BudgetRules.calculateStatus(spent: 500000, budget: 1000000);
      expect(underLimit.remaining, 500000);
      expect(underLimit.progress, 0.5);
      expect(underLimit.isNearLimit, isFalse);

      final nearLimit =
          BudgetRules.calculateStatus(spent: 850000, budget: 1000000);
      expect(nearLimit.isNearLimit, isTrue);

      final exhausted =
          BudgetRules.calculateStatus(spent: 1000000, budget: 1000000);
      expect(exhausted.isExhausted, isTrue);
      expect(exhausted.isNearLimit, isFalse);

      final exceeded =
          BudgetRules.calculateStatus(spent: 1200000, budget: 1000000);
      expect(exceeded.remaining, -200000);
      expect(exceeded.progress, 1);
      expect(exceeded.percentage, 120);
      expect(exceeded.isExceeded, isTrue);
    });
  });

  testWidgets('saves budget from profile settings',
      (WidgetTester tester) async {
    final repository = _MemoryBudgetRepository();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MonthlyBudgetSettings(repository: repository),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '1500000');
    await tester.tap(find.text('Simpan anggaran'));
    await tester.pumpAndSettle();

    expect(repository.budget, 1500000);
    expect(find.text('Anggaran bulanan berhasil disimpan.'), findsOneWidget);
  });

  testWidgets('shows when spending exceeds the monthly budget',
      (WidgetTester tester) async {
    final status = BudgetRules.calculateStatus(
      spent: 1200000,
      budget: 1000000,
    );
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: MonthlyBudgetCard(status: status))),
    );

    expect(find.text('Melebihi anggaran sebesar Rp200.000'), findsOneWidget);
    expect(find.text('120%'), findsOneWidget);
  });
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
