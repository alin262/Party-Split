import 'package:flutter/material.dart';
import 'package:partysplit/services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  void _setLoading(bool value) {
    if (mounted) setState(() => _isLoading = value);
  }

  Future<void> _handleGoogleSignIn() async {
    _setLoading(true);
    try {
      await AuthService().signInWithGoogle();
    } catch (e) {
      _setLoading(false);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign-in failed: $e')));
      return;
    }

    if (!mounted) return;
    _setLoading(false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  Future<void> _handleGuestSignIn() async {
    _setLoading(true);
    try {
      await AuthService().signInGuest();
    } catch (e) {
      _setLoading(false);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Guest sign-in failed: $e')));
      return;
    }

    if (!mounted) return;
    _setLoading(false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.celebration, size: 72),
              const SizedBox(height: 16),
              const Text(
                'SPLITTy',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Split party expenses with friends',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 48),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                OutlinedButton.icon(
                  onPressed: _handleGoogleSignIn,
                  icon: Image.asset('lib/assets/images/google.png', width: 20),
                  label: const Text('Continue with Google'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _handleGuestSignIn,
                  child: const Text('Continue as Guest'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
