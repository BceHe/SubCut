import 'package:flutter/material.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../routes/app_routes.dart';
import '../../subscriptions/data/subscription_repository.dart';
import '../../subscriptions/models/subscription.dart';
import '../../subscriptions/widgets/subscription_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _repository = SubscriptionRepository();
  late Future<List<Subscription>> _subscriptionsFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _subscriptionsFuture = _repository.getActiveSubscriptions();
  }

  Future<void> _openForm([Subscription? subscription]) async {
    final changed = await Navigator.pushNamed(
      context,
      AppRoutes.subscriptionForm,
      arguments: subscription,
    );
    if (changed == true && mounted) {
      setState(_reload);
    }
  }

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
      body: FutureBuilder<List<Subscription>>(
        future: _subscriptionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }
          final subscriptions = snapshot.data ?? const <Subscription>[];
          final monthlyBurnRate = subscriptions.fold<double>(
            0,
            (total, item) => total + item.monthlyCost,
          ).round();
          return RefreshIndicator(
            onRefresh: () async => setState(_reload),
            child: ListView(
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
                        Text(formatIdr(monthlyBurnRate), style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 4),
                        Text('${formatIdr(monthlyBurnRate * 12)} estimasi tahunan'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Langganan terdekat', style: Theme.of(context).textTheme.titleLarge),
                    Text('${subscriptions.length} aktif'),
                  ],
                ),
                const SizedBox(height: 8),
                if (subscriptions.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Belum ada langganan. Tambahkan data pertama Anda.'),
                    ),
                  ),
                ...subscriptions.map(
                  (subscription) => SubscriptionCard(
                    subscription: subscription,
                    onTap: () async {
                      final changed = await Navigator.pushNamed(
                        context,
                        AppRoutes.detail,
                        arguments: subscription,
                      );
                      if (changed == true && mounted) {
                        setState(_reload);
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openForm,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}
