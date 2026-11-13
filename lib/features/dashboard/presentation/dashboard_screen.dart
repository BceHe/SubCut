import 'package:flutter/material.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../routes/app_routes.dart';
import '../../settings/data/budget_repository.dart';
import '../../settings/domain/budget_rules.dart';
import '../widgets/monthly_budget_card.dart';
import '../../subscriptions/data/subscription_repository.dart';
import '../../subscriptions/models/subscription.dart';
import '../../subscriptions/widgets/subscription_card.dart';
import '../../subscriptions/domain/subscription_business_rules.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({this.budgetRepository, super.key});

  final BudgetRepository? budgetRepository;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _repository = SubscriptionRepository();
  late final BudgetRepository _budgetRepository;
  late Future<({List<Subscription> subscriptions, int? budget})> _dataFuture;

  @override
  void initState() {
    super.initState();
    _budgetRepository = widget.budgetRepository ?? BudgetRepository();
    _reload();
  }

  void _reload() {
    _dataFuture = _loadDashboardData();
  }

  Future<({List<Subscription> subscriptions, int? budget})>
      _loadDashboardData() async {
    final subscriptions = await _repository.getActiveSubscriptions();
    final budget = await _budgetRepository.getMonthlyBudget();
    return (subscriptions: subscriptions, budget: budget);
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

  Future<void> _openProfile() async {
    await Navigator.pushNamed(context, AppRoutes.profile);
    if (mounted) {
      setState(_reload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Ringkasan'),
        actions: [
          IconButton(
            tooltip: 'Profil',
            onPressed: _openProfile,
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: FutureBuilder<({List<Subscription> subscriptions, int? budget})>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }
          final data = snapshot.data!;
          final subscriptions = data.subscriptions;
          final monthlyBurnRate =
              SubscriptionBusinessRules.monthlyBurnRate(subscriptions);
          return RefreshIndicator(
            onRefresh: () async => setState(_reload),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              children: [
                Text('Halo, selamat datang kembali',
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 4),
                Text('Pantau biaya berulangmu dengan tenang.',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 20),
                Card(
                  color: Theme.of(context).colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Burn rate bulanan',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: .8))),
                        const SizedBox(height: 8),
                        Text(formatIdr(monthlyBurnRate),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(
                            '${formatIdr(monthlyBurnRate * 12)} estimasi tahunan',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: .8))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (data.budget case final budget?)
                  MonthlyBudgetCard(
                    status: BudgetRules.calculateStatus(
                      spent: monthlyBurnRate,
                      budget: budget,
                    ),
                  )
                else
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.savings_outlined),
                      title: const Text('Atur anggaran bulanan'),
                      subtitle:
                          const Text('Bandingkan pengeluaran dengan batasmu.'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _openProfile,
                    ),
                  ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Langganan aktif',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    Text('${subscriptions.length} layanan',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 8),
                if (subscriptions.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                          'Belum ada langganan. Tambahkan data pertama Anda.'),
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
