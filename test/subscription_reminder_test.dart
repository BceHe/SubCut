import 'package:flutter_test/flutter_test.dart';
import 'package:subcut/features/subscriptions/domain/subscription_business_rules.dart';

void main() {
  test('creates H-3 and H-1 reminders at 09:00', () {
    final dates = SubscriptionBusinessRules.reminderDates(
      DateTime(2026, 11, 20), now: DateTime(2026, 11, 1),
    );
    expect(dates, [DateTime(2026, 11, 17, 9), DateTime(2026, 11, 19, 9)]);
  });

  test('does not return reminders that already passed', () {
    final dates = SubscriptionBusinessRules.reminderDates(
      DateTime(2026, 11, 20), now: DateTime(2026, 11, 18),
    );
    expect(dates, [DateTime(2026, 11, 19, 9)]);
  });
}
