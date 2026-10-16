import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:subcut/core/database/local_database.dart';
import 'package:subcut/features/subscriptions/data/subscription_repository.dart';
import 'package:subcut/features/subscriptions/models/subscription.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('subscription CRUD persists after database is reopened', (tester) async {
    final repository = SubscriptionRepository();
    final subscription = Subscription(
      name: 'Persistence test ${DateTime.now().microsecondsSinceEpoch}',
      category: 'Testing',
      price: 125000,
      billingCycle: BillingCycle.monthly,
      nextDueDate: DateTime.now().add(const Duration(days: 30)),
    );

    final id = await repository.insert(subscription);
    await LocalDatabase.instance.close();

    final reopenedRepository = SubscriptionRepository();
    var restored = await reopenedRepository.getById(id);
    expect(restored, isNotNull);
    expect(restored!.name, subscription.name);
    expect(restored.price, subscription.price);

    await reopenedRepository.update(restored.copyWith(name: 'Updated persistence test'));
    await LocalDatabase.instance.close();

    restored = await SubscriptionRepository().getById(id);
    expect(restored?.name, 'Updated persistence test');

    await SubscriptionRepository().delete(id);
    await LocalDatabase.instance.close();

    final activeSubscriptions = await SubscriptionRepository().getActiveSubscriptions();
    expect(activeSubscriptions.any((item) => item.id == id), isFalse);
    await LocalDatabase.instance.close();
  });
}
