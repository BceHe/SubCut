class BudgetStatus {
  const BudgetStatus({
    required this.spent,
    required this.budget,
  });

  final int spent;
  final int budget;

  int get remaining => budget - spent;
  double get progress => (spent / budget).clamp(0, 1).toDouble();
  double get percentage => spent / budget * 100;
  bool get isExceeded => spent > budget;
  bool get isExhausted => spent == budget;
  bool get isNearLimit => spent >= budget * 0.8 && spent < budget;
}

class BudgetRules {
  const BudgetRules._();

  static String? validateBudgetInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Anggaran wajib diisi.';
    }
    final amount = parseBudget(value);
    if (amount == null || amount <= 0) {
      return 'Masukkan anggaran berupa angka lebih dari 0.';
    }
    return null;
  }

  static int? parseBudget(String value) {
    final normalized = value.trim();
    final isValidNumber = RegExp(r'^\d+$').hasMatch(normalized);
    final isValidGroupedNumber =
        RegExp(r'^\d{1,3}(?:\.\d{3})+$').hasMatch(normalized);
    if (!isValidNumber && !isValidGroupedNumber) {
      return null;
    }
    return int.tryParse(normalized.replaceAll('.', ''));
  }

  static BudgetStatus calculateStatus({
    required int spent,
    required int budget,
  }) {
    if (spent < 0 || budget <= 0) {
      throw ArgumentError(
          'Spent must be non-negative and budget must be positive.');
    }
    return BudgetStatus(spent: spent, budget: budget);
  }
}
