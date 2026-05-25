import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/remote/sync_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.isLinking = false});
  final bool isLinking;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _handleSubmit() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final syncService = context.read<SyncService>();
    try {
      if (widget.isLinking) {
        await syncService.linkWithEmail(_emailController.text, _passwordController.text);
      } else {
        await syncService.signInWithEmail(_emailController.text, _passwordController.text);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      appBar: AppBar(
        title: Text(widget.isLinking ? 'Secure Your Progress' : 'Sign In'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.xxl),
            Icon(
              widget.isLinking ? Icons.cloud_done_rounded : Icons.account_circle_rounded,
              size: 80,
              color: colors.accentPrimary,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              widget.isLinking 
                ? 'Create an account to save your anonymous study history to the cloud.' 
                : 'Sign in to sync your progress across all your devices.',
              style: textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxxl),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: const Icon(Icons.email_outlined),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.accentPrimary)),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.accentPrimary)),
              ),
              obscureText: true,
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                _error!,
                style: TextStyle(color: colors.accentDanger, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: AppSpacing.xxxl),
            FilledButton(
              onPressed: _isLoading ? null : _handleSubmit,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: colors.accentPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(widget.isLinking ? 'Link Account' : 'Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
