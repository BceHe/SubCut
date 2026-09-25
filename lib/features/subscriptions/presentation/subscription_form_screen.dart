import 'package:flutter/material.dart';

import '../../../core/services/local_notification_service.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../data/subscription_repository.dart';
import '../models/subscription.dart';

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
    final name = _nameController.text.trim();
    final category = _categoryController.text.trim();
    final price = int.tryParse(_priceController.text.replaceAll('.', '').trim());
    if (name.isEmpty || category.isEmpty || price == null || price < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi nama, kategori, dan biaya dengan benar.')),
      );
      return;
    }

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
    final savedId = widget.subscription?.id ?? await _repository.insert(subscription);
    if (widget.subscription == null) {
      await _scheduleReminders(savedId, subscription);
    } else {
      await _repository.update(subscription);
      await _scheduleReminders(savedId, subscription);
    }
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _scheduleReminders(int id, Subscription subscription) async {
    for (final daysBefore in [3, 1]) {
      final dueDate = subscription.nextDueDate;
      final scheduledAt = DateTime(
        dueDate.year,
        dueDate.month,
        dueDate.day,
        9,
      ).subtract(Duration(days: daysBefore));
      await LocalNotificationService.instance.scheduleReminder(
        id: id * 10 + daysBefore,
        title: 'Pengingat langganan',
        body: '${subscription.name} jatuh tempo dalam $daysBefore hari.',
        scheduledAt: scheduledAt,
      );
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
    final price = int.tryParse(_priceController.text.replaceAll('.', '').trim()) ?? 0;
    return _billingCycle == BillingCycle.yearly ? (price / 12).round() : price;
  }
}
