import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flippa/core/auth/auth_service.dart';

/// Example widget demonstrating Google Sign-In
class GoogleSignInButton extends StatefulWidget {
  final String role;
  final VoidCallback? onSuccess;
  final Function(String)? onError;

  const GoogleSignInButton({
    super.key,
    this.role = 'consumer',
    this.onSuccess,
    this.onError,
  });

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      await _authService.signInWithGoogle(role: widget.role);
      if (mounted) {
        widget.onSuccess?.call();
      }
    } catch (e) {
      if (mounted) {
        widget.onError?.call(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign-In failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _handleGoogleSignIn,
      icon: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.login, color: Colors.blue), // Using Icon as placeholder for missing asset
      label: Text(_isLoading ? 'Signing in...' : 'Sign in with Google'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}

/// Example widget demonstrating Phone Authentication
class PhoneAuthWidget extends StatefulWidget {
  final String role;
  final VoidCallback? onSuccess;
  final Function(String)? onError;

  const PhoneAuthWidget({
    super.key,
    this.role = 'consumer',
    this.onSuccess,
    this.onError,
  });

  @override
  State<PhoneAuthWidget> createState() => _PhoneAuthWidgetState();
}

class _PhoneAuthWidgetState extends State<PhoneAuthWidget> {
  final AuthService _authService = AuthService();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isLoading = false;
  bool _codeSent = false;
  String? _verificationId;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _sendVerificationCode() async {
    final phoneNumber = _phoneController.text.trim();
    
    if (phoneNumber.isEmpty) {
      _showError('Please enter a phone number');
      return;
    }

    // Phone number should be in E.164 format (e.g., +1234567890)
    if (!phoneNumber.startsWith('+')) {
      _showError('Phone number must include country code (e.g., +1234567890)');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: (String verificationId, int? resendToken) {
          if (mounted) {
            setState(() {
              _verificationId = verificationId;
              _codeSent = true;
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Verification code sent!')),
            );
          }
        },
        verificationFailed: (FirebaseAuthException error) {
          if (mounted) {
            setState(() => _isLoading = false);
            _showError('Verification failed: ${error.message}');
          }
        },
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification (Android only)
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);
            if (mounted) {
              widget.onSuccess?.call();
            }
          } catch (e) {
            if (mounted) {
              _showError('Sign-in failed: $e');
            }
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('Error: $e');
      }
    }
  }

  Future<void> _verifyCode() async {
    final code = _codeController.text.trim();
    
    if (code.isEmpty) {
      _showError('Please enter the verification code');
      return;
    }

    if (_verificationId == null) {
      _showError('Verification ID not found. Please resend code.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signInWithPhoneNumber(
        verificationId: _verificationId!,
        smsCode: code,
        role: widget.role,
      );
      
      if (mounted) {
        widget.onSuccess?.call();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('Verification failed: $e');
      }
    }
  }

  void _showError(String message) {
    widget.onError?.call(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!_codeSent) ...[
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: '+1234567890',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            enabled: !_isLoading,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _sendVerificationCode,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Send Verification Code'),
          ),
        ] else ...[
          Text(
            'Verification code sent to ${_phoneController.text}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _codeController,
            decoration: const InputDecoration(
              labelText: 'Verification Code',
              hintText: '123456',
              prefixIcon: Icon(Icons.sms),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            maxLength: 6,
            enabled: !_isLoading,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _verifyCode,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Verify Code'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _isLoading
                ? null
                : () {
                    setState(() {
                      _codeSent = false;
                      _verificationId = null;
                      _codeController.clear();
                    });
                  },
            child: const Text('Change Phone Number'),
          ),
        ],
      ],
    );
  }
}

/// Example usage in a login screen
class ExampleLoginScreen extends StatelessWidget {
  const ExampleLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Google Sign-In Button
            GoogleSignInButton(
              role: 'consumer',
              onSuccess: () {
                // Navigate to home screen
                context.go('/');
              },
              onError: (error) {
                // Handle error
                debugPrint('Google Sign-In Error: $error');
              },
            ),
            
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            
            // Phone Authentication
            PhoneAuthWidget(
              role: 'consumer',
              onSuccess: () {
                // Navigate to home screen
                context.go('/');
              },
              onError: (error) {
                // Handle error
                debugPrint('Phone Auth Error: $error');
              },
            ),
          ],
        ),
      ),
    );
  }
}
