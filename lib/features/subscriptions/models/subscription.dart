enum BillingCycle { monthly, yearly }

class Subscription {
  const Subscription({
    this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.billingCycle,
    required this.nextDueDate,
    this.isTrial = false,
    this.trialEndDate,
    this.merchantKey,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  final int? id;
  final String name;
  final String category;
  final int price;
  final BillingCycle billingCycle;
  final DateTime nextDueDate;
  final bool isTrial;
  final DateTime? trialEndDate;
  final String? merchantKey;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  double get monthlyCost => billingCycle == BillingCycle.monthly ? price.toDouble() : price / 12;

  Subscription copyWith({
    int? id,
    String? name,
    String? category,
    int? price,
    BillingCycle? billingCycle,
    DateTime? nextDueDate,
    bool? isTrial,
    DateTime? trialEndDate,
    String? merchantKey,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      billingCycle: billingCycle ?? this.billingCycle,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      isTrial: isTrial ?? this.isTrial,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      merchantKey: merchantKey ?? this.merchantKey,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'billing_cycle': billingCycle.name,
      'next_due_date': nextDueDate.toUtc().toIso8601String(),
      'is_trial': isTrial ? 1 : 0,
      'trial_end_date': trialEndDate?.toUtc().toIso8601String(),
      'merchant_key': merchantKey,
      'created_at': (createdAt ?? DateTime.now()).toUtc().toIso8601String(),
      'updated_at': (updatedAt ?? DateTime.now()).toUtc().toIso8601String(),
      'is_active': isActive ? 1 : 0,
    };
  }

  factory Subscription.fromMap(Map<String, Object?> map) {
    return Subscription(
      id: map['id'] as int?,
      name: map['name'] as String,
      category: map['category'] as String,
      price: map['price'] as int,
      billingCycle: BillingCycle.values.byName(map['billing_cycle'] as String),
      nextDueDate: DateTime.parse(map['next_due_date'] as String).toLocal(),
      isTrial: (map['is_trial'] as int) == 1,
      trialEndDate: map['trial_end_date'] == null
          ? null
          : DateTime.parse(map['trial_end_date'] as String).toLocal(),
      merchantKey: map['merchant_key'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String).toLocal(),
      updatedAt: DateTime.parse(map['updated_at'] as String).toLocal(),
      isActive: (map['is_active'] as int) == 1,
    );
  }
}
