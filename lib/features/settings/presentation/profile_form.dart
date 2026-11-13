import 'package:flutter/material.dart';

import '../data/profile_repository.dart';
import '../domain/profile_validation.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({
    required this.repository,
    required this.onSaved,
    super.key,
  });

  final ProfileRepository repository;
  final ValueChanged<String> onSaved;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isSaving = false;
  String? _saveError;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    setState(() {
      _isSaving = true;
      _saveError = null;
    });

    try {
      await widget.repository.saveName(name);
      if (mounted) {
        widget.onSaved(name);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _saveError = 'Gagal menyimpan nama: $error';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selamat datang di SubCut')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sebelum mulai',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Siapa nama Anda?',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(labelText: 'Nama'),
                  validator: ProfileValidation.validateName,
                  onFieldSubmitted: (_) => _isSaving ? null : _saveName(),
                ),
                if (_saveError != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _saveError!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _isSaving ? null : _saveName,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Mulai menggunakan SubCut'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
