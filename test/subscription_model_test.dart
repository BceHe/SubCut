import 'package:flutter_test/flutter_test.dart';

import 'package:subcut/features/subscriptions/models/subscription.dart';

void main() {
  test('converts yearly price to monthly cost', () {
    final subscription = Subscription(
      name: 'Cloud Storage',
      category: 'Produktivitas',
      price: 1200000,
      billingCycle: BillingCycle.yearly,
      nextDueDate: DateTime(2026, 10, 1),
    );

    expect(subscription.monthlyCost, 100000);
  });

  test('serializes and restores a subscription', () {
    final subscription = Subscription(
      id: 1,
      name: 'Streaming',
      category: 'Hiburan',
      price: 150000,
      billingCycle: BillingCycle.monthly,
      nextDueDate: DateTime(2026, 10, 1),
    );

    final restored = Subscription.fromMap(subscription.toMap());

    expect(restored.id, 1);
    expect(restored.name, 'Streaming');
    expect(restored.price, 150000);
    expect(restored.billingCycle, BillingCycle.monthly);
  });
}