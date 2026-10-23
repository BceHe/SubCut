import 'package:flutter_test/flutter_test.dart';
import 'package:subcut/features/subscriptions/domain/subscription_business_rules.dart';

void main() {
  test('requires name and category', () {
    expect(SubscriptionBusinessRules.validateInput(name: '', category: 'Hiburan', priceText: '10000').isValid, isFalse);
    expect(SubscriptionBusinessRules.validateInput(name: 'Netflix', category: '', priceText: '10000').isValid, isFalse);
  });

  test('accepts a formatted non-negative price', () {
    final result = SubscriptionBusinessRules.validateInput(name: 'Netflix', category: 'Hiburan', priceText: '150.000');
    expect(result.isValid, isTrue);
  });
}
