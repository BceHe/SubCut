import 'package:flutter/material.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final user = await _authService.signIn(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) {
      return;
    }

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan kata sandi wajib diisi.')),
      );
      return;
    }

    Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.account_balance_wallet_outlined, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Selamat datang di SubCut',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pantau langganan dan pengeluaran berulang Anda.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  AppTextField(label: 'Email', controller: _emailController),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Kata sandi',
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(label: 'Masuk', onPressed: _signIn),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
