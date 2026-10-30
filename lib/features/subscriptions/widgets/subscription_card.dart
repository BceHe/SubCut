import 'package:flutter/material.dart';

import '../../../core/utils/currency_formatter.dart';
import '../models/subscription.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
    required this.subscription,
    required this.onTap,
    super.key,
  });

  final Subscription subscription;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(Icons.subscriptions_outlined,
              color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(subscription.name,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
          '${subscription.category} • Jatuh tempo ${subscription.nextDueDate.day}/${subscription.nextDueDate.month}/${subscription.nextDueDate.year}',
        ),
        trailing: Text(formatIdr(subscription.price),
            style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}
