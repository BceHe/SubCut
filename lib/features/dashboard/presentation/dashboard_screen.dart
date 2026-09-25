import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';
import '../../subscriptions/widgets/subscription_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Profil',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Ringkasan pengeluaran', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Burn rate bulanan'),
                  const SizedBox(height: 8),
                  Text('Rp450.000', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  const Text('Rp5.400.000 estimasi tahunan'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Langganan terdekat', style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.detail),
                child: const Text('Lihat detail'),
              ),
            ],
          ),
          const SubscriptionCard(
            name: 'Streaming Premium',
            price: 'Rp150.000',
            nextDueDate: '3 hari lagi',
          ),
          const SubscriptionCard(
            name: 'Cloud Storage',
            price: 'Rp75.000',
            nextDueDate: '8 hari lagi',
          ),
        ],
      ),
    );
  }
}
