import 'package:flutter_test/flutter_test.dart';
import 'package:subcut/features/subscriptions/domain/subscription_business_rules.dart';

void main() {
  test('parses Indonesian thousand separators', () {
    expect(SubscriptionBusinessRules.parsePrice('1.250.000'), 1250000);
    expect(SubscriptionBusinessRules.parsePrice(' 450000 '), 450000);
  });

  test('invalid price safely becomes zero for preview', () {
    expect(SubscriptionBusinessRules.parsePrice('not-a-number'), 0);
  });
}
