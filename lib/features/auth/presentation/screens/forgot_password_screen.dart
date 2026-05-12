import 'package:flutter/material.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/parent_repository.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  bool _loading = false;
  bool _success = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _reset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final db = await AppDatabase.instance.database;
      final repo = ParentRepository(db);
      // Identify parent by email first
      final parent = await repo.login(
        email: _emailCtrl.text,
        password: _oldPassCtrl.text,
      );
      if (!mounted) return;
      if (parent == null) {
        setState(() => _error = 'Email or current password is incorrect.');
        return;
      }
      final changed = await repo.changePassword(
        parentId: parent.id,
        email: _emailCtrl.text,
        oldPassword: _oldPassCtrl.text,
        newPassword: _newPassCtrl.text,
      );
      if (!mounted) return;
      if (changed) {
        setState(() => _success = true);
      } else {
        setState(() => _error = 'Failed to change password. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEF7F0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Reset Password',
          style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _success ? _successView() : _formView(),
        ),
      ),
    );
  }

  Widget _successView() => Column(
        children: [
          const SizedBox(height: 60),
          const Icon(Icons.check_circle, color: Color(0xFF6DB072), size: 80),
          const SizedBox(height: 16),
          const Text(
            'Password changed successfully!',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'arlrdbd', fontSize: 20),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF19335),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Back to Login',
              style: TextStyle(fontFamily: 'arlrdbd', color: Colors.white),
            ),
          ),
        ],
      );

  Widget _formView() => Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your email and current password to set a new password.',
              style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black54),
            ),
            const SizedBox(height: 24),
            _field(
              controller: _emailCtrl,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 16),
            _field(
              controller: _oldPassCtrl,
              label: 'Current Password',
              icon: Icons.lock_outline,
              obscure: true,
              validator: (v) =>
                  (v == null || v.length < 6) ? 'Min 6 characters' : null,
            ),
            const SizedBox(height: 16),
            _field(
              controller: _newPassCtrl,
              label: 'New Password',
              icon: Icons.lock_reset,
              obscure: true,
              validator: (v) =>
                  (v == null || v.length < 6) ? 'Min 6 characters' : null,
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red, fontFamily: 'arlrdbd'),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _loading ? null : _reset,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF19335),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Reset Password',
                        style: TextStyle(
                          fontFamily: 'arlrdbd',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      );

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'arlrdbd'),
        prefixIcon: Icon(icon, color: const Color(0xFFF19335)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF19335), width: 2),
        ),
      ),
    );
  }
}
