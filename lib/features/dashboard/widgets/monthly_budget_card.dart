import 'package:flutter/material.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../settings/domain/budget_rules.dart';

class MonthlyBudgetCard extends StatelessWidget {
  const MonthlyBudgetCard({
    required this.status,
    super.key,
  });

  final BudgetStatus status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = status.isExceeded
        ? colorScheme.error
        : status.isNearLimit
            ? Colors.deepOrange
            : colorScheme.primary;
    final message = status.isExceeded
        ? 'Melebihi anggaran sebesar ${formatIdr(-status.remaining)}'
        : status.isExhausted
            ? 'Anggaran habis'
            : status.isNearLimit
                ? 'Anggaran hampir habis'
                : 'Sisa anggaran ${formatIdr(status.remaining)}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Anggaran bulanan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${formatIdr(status.spent)} dari ${formatIdr(status.budget)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: status.progress,
                    color: statusColor,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Text('${status.percentage.toStringAsFixed(0)}%'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
