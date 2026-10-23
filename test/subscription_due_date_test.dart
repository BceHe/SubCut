import 'package:flutter_test/flutter_test.dart';
import 'package:subcut/features/subscriptions/domain/subscription_business_rules.dart';
import 'package:subcut/features/subscriptions/models/subscription.dart';

Subscription _item(String name, int day) => Subscription(
      name: name, category: 'Test', price: 1, billingCycle: BillingCycle.monthly,
      nextDueDate: DateTime(2026, 11, day),
    );

void main() {
  test('sorts subscriptions by nearest due date', () {
    final sorted = SubscriptionBusinessRules.sortByNextDueDate([_item('Late', 20), _item('Soon', 3)]);
    expect(sorted.map((item) => item.name), ['Soon', 'Late']);
  });
}
