import 'package:flutter_test/flutter_test.dart';
import 'package:subcut/features/subscriptions/domain/subscription_business_rules.dart';
import 'package:subcut/features/subscriptions/models/subscription.dart';

Subscription _subscription(int price, BillingCycle cycle, {bool active = true}) => Subscription(
      name: 'Service', category: 'Test', price: price, billingCycle: cycle,
      nextDueDate: DateTime(2026, 12, 1), isActive: active,
    );

void main() {
  test('calculates monthly burn rate and excludes inactive subscriptions', () {
    final total = SubscriptionBusinessRules.monthlyBurnRate([
      _subscription(120000, BillingCycle.monthly),
      _subscription(1200000, BillingCycle.yearly),
      _subscription(90000, BillingCycle.monthly, active: false),
    ]);
    expect(total, 220000);
  });
}
