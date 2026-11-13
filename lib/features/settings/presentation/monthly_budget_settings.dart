import 'package:flutter/material.dart';

import '../../../core/utils/currency_formatter.dart';
import '../data/budget_repository.dart';
import '../domain/budget_rules.dart';

class MonthlyBudgetSettings extends StatefulWidget {
  const MonthlyBudgetSettings({required this.repository, super.key});

  final BudgetRepository repository;

  @override
  State<MonthlyBudgetSettings> createState() => _MonthlyBudgetSettingsState();
}

class _MonthlyBudgetSettingsState extends State<MonthlyBudgetSettings> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  int? _monthlyBudget;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _loadBudget();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadBudget() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final budget = await widget.repository.getMonthlyBudget();
      if (!mounted) return;
      setState(() {
        _monthlyBudget = budget;
        _amountController.text = budget?.toString() ?? '';
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Gagal memuat anggaran: $error';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveBudget() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;

    final amount = BudgetRules.parseBudget(_amountController.text)!;
    setState(() {
      _isSaving = true;
      _errorMessage = null;
      _successMessage = null;
    });
    try {
      await widget.repository.saveMonthlyBudget(amount);
      if (!mounted) return;
      setState(() {
        _monthlyBudget = amount;
        _successMessage = 'Anggaran bulanan berhasil disimpan.';
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal menyimpan anggaran: $error';
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

  Future<void> _clearBudget() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
      _successMessage = null;
    });
    try {
      await widget.repository.clearMonthlyBudget();
      if (!mounted) return;
      setState(() {
        _monthlyBudget = null;
        _amountController.clear();
        _successMessage = 'Anggaran bulanan dihapus.';
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal menghapus anggaran: $error';
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null && _monthlyBudget == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_errorMessage!),
          TextButton(onPressed: _loadBudget, child: const Text('Coba lagi')),
        ],
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _monthlyBudget == null
                ? 'Belum ada anggaran yang ditetapkan.'
                : 'Anggaran saat ini: ${formatIdr(_monthlyBudget!)}',
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Anggaran per bulan',
              prefixText: 'Rp ',
              hintText: 'Contoh: 1500000',
            ),
            validator: BudgetRules.validateBudgetInput,
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          if (_successMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _successMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ],
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _isSaving ? null : _saveBudget,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Simpan anggaran'),
          ),
          if (_monthlyBudget != null)
            TextButton(
              onPressed: _isSaving ? null : _clearBudget,
              child: const Text('Hapus anggaran'),
            ),
        ],
      ),
    );
  }
}
