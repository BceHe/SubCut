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
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(child: Icon(Icons.subscriptions_outlined)),
        title: Text(subscription.name),
        subtitle: Text(
          'Jatuh tempo ${subscription.nextDueDate.day}/${subscription.nextDueDate.month}/${subscription.nextDueDate.year}',
        ),
        trailing: Text(formatIdr(subscription.price)),
      ),
    );
  }
}
