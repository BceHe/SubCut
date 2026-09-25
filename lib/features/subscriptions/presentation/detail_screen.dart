import 'package:flutter/material.dart';

import '../../../core/widgets/primary_button.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail langganan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Streaming Premium', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          const ListTile(
            leading: Icon(Icons.payments_outlined),
            title: Text('Biaya'),
            subtitle: Text('Rp150.000 per bulan'),
          ),
          const ListTile(
            leading: Icon(Icons.calendar_month_outlined),
            title: Text('Tanggal berikutnya'),
            subtitle: Text('28 September 2026'),
          ),
          const ListTile(
            leading: Icon(Icons.category_outlined),
            title: Text('Kategori'),
            subtitle: Text('Hiburan'),
          ),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Buka halaman pengelolaan', onPressed: () {}),
        ],
      ),
    );
  }
}
