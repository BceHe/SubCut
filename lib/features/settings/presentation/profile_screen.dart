import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(radius: 36, child: Icon(Icons.person_outline, size: 36)),
          const SizedBox(height: 12),
          Text('Pengguna SubCut', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          const Text('pengguna@subcut.local', textAlign: TextAlign.center),
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
            onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
            icon: const Icon(Icons.logout),
            label: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
