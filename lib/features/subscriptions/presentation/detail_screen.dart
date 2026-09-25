import 'package:flutter/material.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../routes/app_routes.dart';
import '../data/subscription_repository.dart';
import '../models/subscription.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({required this.subscription, super.key});

  final Subscription subscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail langganan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(subscription.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          ListTile(
            leading: Icon(Icons.payments_outlined),
            title: Text('Biaya'),
            subtitle: Text(
              '${formatIdr(subscription.price)} per ${subscription.billingCycle == BillingCycle.monthly ? 'bulan' : 'tahun'}',
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_month_outlined),
            title: Text('Tanggal berikutnya'),
            subtitle: Text(
              '${subscription.nextDueDate.day}/${subscription.nextDueDate.month}/${subscription.nextDueDate.year}',
            ),
          ),
          ListTile(
            leading: Icon(Icons.category_outlined),
            title: Text('Kategori'),
            subtitle: Text(subscription.category),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Edit langganan',
            onPressed: () async {
              final changed = await Navigator.pushNamed(
                context,
                AppRoutes.subscriptionForm,
                arguments: subscription,
              );
              if (changed == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Hapus langganan?'),
                  content: const Text('Data akan disembunyikan dari dashboard.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: const Text('Batal'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );
              if (confirmed == true && subscription.id != null) {
                await SubscriptionRepository().delete(subscription.id!);
                if (context.mounted) {
                  Navigator.pop(context, true);
                }
              }
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text('Hapus langganan'),
          ),
        ],
      ),
    );
  }
}
