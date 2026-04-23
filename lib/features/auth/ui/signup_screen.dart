import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import '../../../ui/widgets/glass/glass_container.dart';
import '../../../ui/widgets/glass/glass_button.dart';
import '../../../core/auth/auth_service.dart';
import '../../../core/auth/auth_widgets_example.dart';
import '../../../ui/theme/glass_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_picker/country_picker.dart';
import 'dart:ui_web' as ui;
import 'dart:html' as html;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  
  final _authService = AuthService();
  bool _isLoading = false;
  bool _isPhoneFlow = false;
  bool _otpSent = false;
  String? _verificationId;
  RecaptchaVerifier? _verifier;
  
  Country _selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "India",
    e164Key: "",
  );

  Future<void> _handleSignUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.signUpEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // Register the recaptcha container view factory
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
        'recaptcha-container',
        (int viewId) => html.DivElement()..id = 'recaptcha-container',
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    if (kIsWeb) {
      _verifier?.clear();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFF8F9FD),
                  Colors.blue.withOpacity(0.05),
                  Colors.purple.withOpacity(0.05),
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: GlassContainer(
                  padding: const EdgeInsets.all(40),
                  child: SizedBox(
                    width: 400,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person_add_rounded, size: 50, color: Color(0xFF1E1E2C)),
                        const SizedBox(height: 24),
                        const Text(
                          "Create Account",
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C)),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Join the community of book lovers",
                          style: TextStyle(color: Color(0xFF6B7280)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        _isPhoneFlow 
                            ? _buildPhoneAuthSection()
                            : _buildEmailAuthSection(),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey[300])),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text("OR", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                            ),
                            Expanded(child: Divider(color: Colors.grey[300])),
                          ],
                        ),
                        const SizedBox(height: 24),
                        GoogleSignInButton(
                          onSuccess: () => context.go('/'),
                          onError: (err) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err))),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isPhoneFlow = !_isPhoneFlow;
                              _otpSent = false;
                            });
                            if (_isPhoneFlow && kIsWeb && _verifier == null) {
                              _verifier = RecaptchaVerifier(
                                auth: FirebaseAuth.instance as dynamic,
                                container: 'recaptcha-container',
                                size: RecaptchaVerifierSize.normal,
                                theme: RecaptchaVerifierTheme.light,
                              );
                            }
                          },
                          child: Text(
                            _isPhoneFlow ? "Use Email instead" : "Use Phone Number instead",
                            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?", style: TextStyle(color: Color(0xFF6B7280))),
                            TextButton(
                              onPressed: () => context.go('/login'),
                              child: const Text("Sign In", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (kIsWeb)
            const Positioned(
              left: 0,
              top: 0,
              child: Opacity(
                opacity: 0.01,
                child: SizedBox(
                  height: 1,
                  width: 1,
                  child: HtmlElementView(viewType: 'recaptcha-container'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmailAuthSection() {
    return Column(
      children: [
        _buildTextField(_emailController, "Email", Icons.email_outlined),
        const SizedBox(height: 16),
        _buildTextField(_passwordController, "Password", Icons.lock_outline, obscureText: true),
        const SizedBox(height: 16),
        _buildTextField(_confirmPasswordController, "Confirm Password", Icons.lock_reset_outlined, obscureText: true),
        const SizedBox(height: 32),
        _isLoading
            ? const CircularProgressIndicator()
            : GlassButton(
                label: "Sign Up",
                onPressed: _handleSignUp,
                width: double.infinity,
              ),
      ],
    );
  }

  Widget _buildPhoneAuthSection() {
    return Column(
      children: [
        if (!_otpSent) ...[
          _buildPhoneField(),
          const SizedBox(height: 32),
          _isLoading
              ? const CircularProgressIndicator()
              : GlassButton(
                  label: "Send OTP",
                  onPressed: _sendOtp,
                  width: double.infinity,
                ),
        ] else ...[
          _buildTextField(_otpController, "Verification Code", Icons.sms_outlined, hint: "6-digit OTP"),
          const SizedBox(height: 32),
          _isLoading
              ? const CircularProgressIndicator()
              : GlassButton(
                  label: "Verify & Sign Up",
                  onPressed: _verifyOtp,
                  width: double.infinity,
                ),
          TextButton(
            onPressed: () => setState(() => _otpSent = false),
            child: const Text("Change Phone Number", style: TextStyle(fontSize: 12)),
          ),
        ],
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Phone Number", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E293B))),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: true,
                      onSelect: (Country country) {
                        setState(() => _selectedCountry = country);
                      },
                      countryListTheme: CountryListThemeData(
                        borderRadius: BorderRadius.circular(20),
                        inputDecoration: InputDecoration(
                          hintText: 'Search country',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Text(_selectedCountry.flagEmoji, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 4),
                        Text("+${_selectedCountry.phoneCode}", style: const TextStyle(fontWeight: FontWeight.w600)),
                        const Icon(Icons.arrow_drop_down, size: 20),
                        const VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      hintText: '99999 99999',
                      hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _sendOtp() async {
    debugPrint('SignUpScreen: _sendOtp called');
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      debugPrint('SignUpScreen: Phone is empty');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }

    final fullPhone = "+${_selectedCountry.phoneCode}$phone";
    debugPrint('SignUpScreen: Attempting to send OTP to $fullPhone');

    if (kIsWeb && _verifier == null) {
      debugPrint('SignUpScreen: Initializing RecaptchaVerifier');
      _verifier = RecaptchaVerifier(
        auth: FirebaseAuth.instance as dynamic,
        container: 'recaptcha-container',
        size: RecaptchaVerifierSize.normal,
        theme: RecaptchaVerifierTheme.light,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Starting verification...'), duration: Duration(seconds: 1)),
    );

    setState(() => _isLoading = true);
    try {
      debugPrint('SignUpScreen: Calling verifyPhoneNumber');
      await _authService.verifyPhoneNumber(
        phoneNumber: fullPhone,
        applicationVerifier: kIsWeb ? _verifier : null,
        codeSent: (id, token) {
          setState(() {
            _verificationId = id;
            _otpSent = true;
            _isLoading = false;
          });
        },
        verificationFailed: (e) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Verification failed')));
        },
        verificationCompleted: (creds) async {
          // Auto-verify on android
          await FirebaseAuth.instance.signInWithCredential(creds);
          if (mounted) context.go('/');
        }
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _verifyOtp() async {
    final code = _otpController.text.trim();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter 6-digit OTP')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.signInWithPhoneNumber(
        verificationId: _verificationId!,
        smsCode: code,
      );
      if (mounted) context.go('/');
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E293B))),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              hintText: hint ?? 'Enter your $label',
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
