import 'package:flutter/material.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/core/services/auth_service.dart';
import 'package:provider/provider.dart';

import 'forgot_password_screen.dart';
import 'register_screen.dart';

const _primary = Color(0xFFF19335);
const _primaryDark = Color(0xFFE07A1F);
const _accent = Color(0xFFFFB562);
const _bg = Color(0xFFFEF7F0);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _auth = AuthService();

  bool _loading = false;
  bool _googleLoading = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await _auth.signInWithEmail(
        email: _emailCtrl.text,
        password: _passwordCtrl.text,
      );
      if (!mounted) return;
      await context.read<AppState>().setParent(
            id: result.parent.id,
            email: result.parent.email,
          );
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _googleLoading = true;
      _error = null;
    });
    try {
      final result = await _auth.signInWithGoogle();
      if (!mounted) return;
      await context.read<AppState>().setParent(
            id: result.parent.id,
            email: result.parent.email,
          );
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              const _AuthHero(
                title: 'Welcome Back!',
                subtitle: 'Sign in to continue your child\'s journey',
              ),
              Transform.translate(
                offset: const Offset(0, -28),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _PremiumField(
                            controller: _emailCtrl,
                            label: 'Email',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) =>
                                (v == null || !v.contains('@'))
                                    ? 'Enter a valid email'
                                    : null,
                          ),
                          const SizedBox(height: 16),
                          _PremiumField(
                            controller: _passwordCtrl,
                            label: 'Password',
                            icon: Icons.lock_outline,
                            obscure: _obscure,
                            suffix: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: _primary,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                            validator: (v) => (v == null || v.length < 6)
                                ? 'Min 6 characters'
                                : null,
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 14),
                            _ErrorBanner(message: _error!),
                          ],
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const ForgotPasswordScreen(),
                                ),
                              ),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontFamily: 'arlrdbd',
                                  color: _primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          _GradientButton(
                            label: 'Login',
                            loading: _loading,
                            onPressed:
                                (_loading || _googleLoading) ? null : _login,
                          ),
                          const SizedBox(height: 18),
                          const _OrDivider(),
                          const SizedBox(height: 16),
                          _GoogleButton(
                            label: 'Continue with Google',
                            loading: _googleLoading,
                            onPressed: (_loading || _googleLoading)
                                ? null
                                : _loginWithGoogle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontFamily: 'arlrdbd',
                        color: Colors.black54,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontFamily: 'arlrdbd',
                          color: _primary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthHero extends StatelessWidget {
  final String title;
  final String subtitle;
  const _AuthHero({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 56),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_accent, _primary, _primaryDark],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'arlrdbd',
              fontSize: 26,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'arlrdbd',
              fontSize: 13,
              color: Colors.white.withOpacity(0.92),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscure;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const _PremiumField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    this.suffix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(fontFamily: 'arlrdbd'),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'arlrdbd',
          color: Colors.black54,
        ),
        prefixIcon: Icon(icon, color: _primary),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFFFF8F1),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFFFE3CC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback? onPressed;
  const _GradientButton({
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_primary, _primaryDark],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: disabled
              ? []
              : [
                  BoxShadow(
                    color: _primary.withOpacity(0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onPressed,
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      label,
                      style: const TextStyle(
                        fontFamily: 'arlrdbd',
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback? onPressed;
  const _GoogleButton({
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFE6E6E6)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        icon: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _primary,
                ),
              )
            : const Icon(Icons.g_mobiledata,
                size: 32, color: Color(0xFF4285F4)),
        label: Text(
          label,
          style: const TextStyle(
            fontFamily: 'arlrdbd',
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: Divider(color: Color(0xFFEED9C2))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR',
            style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black45),
          ),
        ),
        Expanded(child: Divider(color: Color(0xFFEED9C2))),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFCDD2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline,
              color: Colors.redAccent, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.redAccent,
                fontFamily: 'arlrdbd',
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
