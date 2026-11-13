import 'package:flutter/material.dart';

import '../data/profile_repository.dart';
import 'profile_form.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class ProfileEntryGate extends StatefulWidget {
  const ProfileEntryGate({required this.repository, super.key});

  final ProfileRepository repository;

  @override
  State<ProfileEntryGate> createState() => _ProfileEntryGateState();
}

class _ProfileEntryGateState extends State<ProfileEntryGate> {
  late Future<String?> _nameFuture;
  String? _savedName;

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  void _loadName() {
    _nameFuture = widget.repository.getName();
  }

  void _onNameSaved(String name) {
    setState(() {
      _savedName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_savedName != null) {
      return const DashboardScreen();
    }

    return FutureBuilder<String?>(
      future: _nameFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
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
            ),
          );
        }
        final name = snapshot.data;
        if (name != null && name.trim().isNotEmpty) {
          return const DashboardScreen();
        }
        return ProfileForm(
          repository: widget.repository,
          onSaved: _onNameSaved,
        );
      },
    );
  }
}
