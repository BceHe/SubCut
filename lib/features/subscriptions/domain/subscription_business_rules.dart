import '../models/subscription.dart';

class SubscriptionValidationResult {
  const SubscriptionValidationResult(this.error);

  final String? error;
  bool get isValid => error == null;
}

class SubscriptionBusinessRules {
  const SubscriptionBusinessRules._();

  static SubscriptionValidationResult validateInput({
    required String name,
    required String category,
    required String priceText,
  }) {
    final price = int.tryParse(priceText.replaceAll('.', '').trim());
    if (name.trim().isEmpty) return const SubscriptionValidationResult('Nama layanan wajib diisi.');
    if (category.trim().isEmpty) return const SubscriptionValidationResult('Kategori wajib diisi.');
    if (price == null || price < 0) return const SubscriptionValidationResult('Biaya harus berupa angka positif.');
    return const SubscriptionValidationResult(null);
  }

  static int parsePrice(String value) => int.tryParse(value.replaceAll('.', '').trim()) ?? 0;

  static int monthlyCost(Subscription subscription) => subscription.monthlyCost.round();

  static int monthlyBurnRate(Iterable<Subscription> subscriptions) => subscriptions
      .where((subscription) => subscription.isActive)
      .fold<int>(0, (total, subscription) => total + monthlyCost(subscription));

  static List<Subscription> sortByNextDueDate(Iterable<Subscription> subscriptions) =>
      subscriptions.toList()..sort((a, b) => a.nextDueDate.compareTo(b.nextDueDate));

  static List<DateTime> reminderDates(DateTime dueDate, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    return [3, 1]
        .map((days) => DateTime(dueDate.year, dueDate.month, dueDate.day, 9).subtract(Duration(days: days)))
        .where((date) => !date.isBefore(reference))
        .toList();
  }
}
