import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/services/local_notification_service.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../data/subscription_repository.dart';
import '../models/subscription.dart';
import '../domain/subscription_business_rules.dart';

class SubscriptionFormScreen extends StatefulWidget {
  const SubscriptionFormScreen({this.subscription, super.key});

  final Subscription? subscription;

  @override
  State<SubscriptionFormScreen> createState() => _SubscriptionFormScreenState();
}

class _SubscriptionFormScreenState extends State<SubscriptionFormScreen> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _repository = SubscriptionRepository();
  late DateTime _nextDueDate;
  BillingCycle _billingCycle = BillingCycle.monthly;
  bool _isTrial = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final subscription = widget.subscription;
    _nameController.text = subscription?.name ?? '';
    _categoryController.text = subscription?.category ?? '';
    _priceController.text = subscription?.price.toString() ?? '';
    _nextDueDate = subscription?.nextDueDate ?? DateTime.now().add(const Duration(days: 30));
    _billingCycle = subscription?.billingCycle ?? BillingCycle.monthly;
    _isTrial = subscription?.isTrial ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _nextDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (selected != null) {
      setState(() => _nextDueDate = selected);
    }
  }

  Future<void> _save() async {
    if (_isSaving) {
      return;
    }

    final name = _nameController.text.trim();
    final category = _categoryController.text.trim();
    final validation = SubscriptionBusinessRules.validateInput(
      name: name,
      category: category,
      priceText: _priceController.text,
    );
    if (!validation.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validation.error!)),
      );
      return;
    }
    final price = SubscriptionBusinessRules.parsePrice(_priceController.text);

    setState(() => _isSaving = true);
    final subscription = Subscription(
      id: widget.subscription?.id,
      name: name,
      category: category,
      price: price,
      billingCycle: _billingCycle,
      nextDueDate: _nextDueDate,
      isTrial: _isTrial,
      createdAt: widget.subscription?.createdAt,
      updatedAt: DateTime.now(),
      isActive: true,
    );
    try {
      final savedId = widget.subscription == null
          ? await _repository.insert(subscription)
          : widget.subscription!.id!;

      if (widget.subscription != null) {
        await _repository.update(subscription);
      }

      if (!mounted) {
        return;
      }

      Navigator.pop(context, true);
      unawaited(_scheduleReminders(savedId, subscription));
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan langganan: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _scheduleReminders(int id, Subscription subscription) async {
    try {
      final dates = SubscriptionBusinessRules.reminderDates(subscription.nextDueDate);
      for (var index = 0; index < dates.length; index++) {
        final daysBefore = [3, 1][index];
        final scheduledAt = dates[index];
        await LocalNotificationService.instance
            .scheduleReminder(
              id: id * 10 + daysBefore,
              title: 'Pengingat langganan',
              body: '${subscription.name} jatuh tempo dalam $daysBefore hari.',
              scheduledAt: scheduledAt,
            )
            .timeout(const Duration(seconds: 5));
      }
    } catch (error) {
      debugPrint('Pengingat langganan gagal dijadwalkan: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.subscription != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit langganan' : 'Tambah langganan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppTextField(label: 'Nama layanan', controller: _nameController),
          const SizedBox(height: 16),
          AppTextField(label: 'Kategori', controller: _categoryController),
          const SizedBox(height: 16),
          AppTextField(label: 'Biaya dalam IDR', controller: _priceController),
          const SizedBox(height: 16),
          DropdownButtonFormField<BillingCycle>(
            initialValue: _billingCycle,
            decoration: const InputDecoration(labelText: 'Siklus tagihan', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: BillingCycle.monthly, child: Text('Bulanan')),
              DropdownMenuItem(value: BillingCycle.yearly, child: Text('Tahunan')),
            ],
            onChanged: (value) => setState(() => _billingCycle = value ?? BillingCycle.monthly),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Jatuh tempo berikutnya'),
            subtitle: Text('${_nextDueDate.day}/${_nextDueDate.month}/${_nextDueDate.year}'),
            trailing: IconButton(onPressed: _selectDate, icon: const Icon(Icons.calendar_month_outlined)),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Masa uji coba'),
            value: _isTrial,
            onChanged: (value) => setState(() => _isTrial = value),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: _isSaving ? 'Menyimpan...' : 'Simpan',
            onPressed: _isSaving ? null : _save,
          ),
          if (pricePreview > 0) ...[
            const SizedBox(height: 12),
            Text('Perkiraan bulanan: ${formatIdr(pricePreview)}'),
          ],
        ],
      ),
    );
  }

  int get pricePreview {
    final price = SubscriptionBusinessRules.parsePrice(_priceController.text);
    return _billingCycle == BillingCycle.yearly ? (price / 12).round() : price;
  }
}
