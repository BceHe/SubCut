import 'package:flutter/material.dart';

import '../data/budget_repository.dart';
import '../data/profile_repository.dart';
import 'monthly_budget_settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    required this.repository,
    required this.budgetRepository,
    super.key,
  });

  final ProfileRepository repository;
  final BudgetRepository budgetRepository;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<String?> _nameFuture;

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  void _loadName() {
    _nameFuture = widget.repository.getName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: FutureBuilder<String?>(
        future: _nameFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Gagal memuat profil: ${snapshot.error}'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => setState(_loadName),
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const CircleAvatar(
                radius: 36,
                child: Icon(Icons.person_outline, size: 36),
              ),
              const SizedBox(height: 12),
              Text(
                snapshot.data ?? 'Nama belum tersedia',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                'Anggaran',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              MonthlyBudgetSettings(repository: widget.budgetRepository),
              const SizedBox(height: 24),
              const ListTile(
                leading: Icon(Icons.notifications_outlined),
                title: Text('Pengingat'),
                subtitle: Text('H-3 dan H-1 sebelum jatuh tempo'),
              ),
              const ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('Penyimpanan lokal'),
                subtitle: Text('Data tersimpan di perangkat'),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali'),
              ),
            ],
          );
        },
      ),
    );
  }
}
