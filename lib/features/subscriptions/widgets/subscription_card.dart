import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
    required this.name,
    required this.price,
    required this.nextDueDate,
    super.key,
  });

  final String name;
  final String price;
  final String nextDueDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.subscriptions_outlined)),
        title: Text(name),
        subtitle: Text('Jatuh tempo $nextDueDate'),
        trailing: Text(price),
      ),
    );
  }
}
