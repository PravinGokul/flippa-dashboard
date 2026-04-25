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
  final PageController _pageController = PageController();
  int _currentStep = 0;
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  
  final _authService = AuthService();
  bool _isLoading = false;
  String? _verificationId;
  RecaptchaVerifier? _verifier;
  AuthMethod _selectedMethod = AuthMethod.email;
  
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
    _pageController.dispose();
    _nameController.dispose();
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

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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
                        _buildStepIndicator(),
                        const SizedBox(height: 32),
                        const Icon(Icons.person_add_rounded, size: 50, color: Color(0xFF1E1E2C)),
                        const SizedBox(height: 24),
                        Text(
                          _currentStep == 0 ? "Create Account" : (_currentStep == 1 ? "User Details" : "Verification"),
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _currentStep == 0 
                              ? "Join the community of book lovers" 
                              : (_currentStep == 1 ? "Complete your profile" : "Finish signing up"),
                          style: const TextStyle(color: Color(0xFF6B7280)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 450, // Fixed height for content area
                          child: PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            onPageChanged: (page) => setState(() => _currentStep = page),
                            children: [
                              _buildMethodSelectionStep(),
                              _buildDetailsStep(),
                              _buildVerificationStep(),
                            ],
                          ),
                        ),
                        if (_currentStep == 0) ...[
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
                        ] else ...[
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _prevStep,
                            child: const Text("Back", style: TextStyle(color: Color(0xFF6B7280))),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (kIsWeb)
            Positioned(
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

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        bool isActive = _currentStep >= index;
        return Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF1E1E2C) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: isActive ? const Color(0xFF1E1E2C) : const Color(0xFFE2E8F0)),
              ),
              child: Center(
                child: isActive && _currentStep > index
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: isActive ? Colors.white : const Color(0xFF94A3B8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            if (index < 2)
              Container(
                width: 40,
                height: 2,
                color: _currentStep > index ? const Color(0xFF1E1E2C) : const Color(0xFFE2E8F0),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildMethodSelectionStep() {
    return Column(
      children: [
        _buildMethodButton(
          "Email & Password",
          "Sign up with email + password",
          Icons.email_outlined,
          AuthMethod.email,
        ),
        const SizedBox(height: 16),
        _buildMethodButton(
          "Phone Number + OTP",
          "Verify via SMS code",
          Icons.phone_android_outlined,
          AuthMethod.phone,
        ),
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
        const Spacer(),
        GlassButton(
          label: "Continue →",
          onPressed: _nextStep,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildMethodButton(String title, String subtitle, IconData icon, AuthMethod method) {
    bool isSelected = _selectedMethod == method;
    return InkWell(
      onTap: () => setState(() => _selectedMethod = method),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? const Color(0xFF1E1E2C) : const Color(0xFFE2E8F0), width: isSelected ? 2 : 1),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))] : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1E1E2C).withOpacity(0.05) : const Color(0xFFF8F9FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: isSelected ? const Color(0xFF1E1E2C) : const Color(0xFF94A3B8)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E1E2C))),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Color(0xFF1E1E2C), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTextField(_nameController, "Full Name", Icons.person_outline, hint: "John Doe"),
          const SizedBox(height: 16),
          _buildTextField(_emailController, "Email", Icons.email_outlined, hint: "john@example.com"),
          if (_selectedMethod == AuthMethod.email) ...[
            const SizedBox(height: 16),
            _buildTextField(_passwordController, "Password", Icons.lock_outline, obscureText: true, hint: "Min 8 characters"),
            const SizedBox(height: 16),
            _buildTextField(_confirmPasswordController, "Confirm Password", Icons.lock_reset_outlined, obscureText: true, hint: "Repeat password"),
          ] else ...[
            const SizedBox(height: 16),
            _buildPhoneField(),
          ],
          const SizedBox(height: 32),
          _isLoading
              ? const CircularProgressIndicator()
              : GlassButton(
                  label: _selectedMethod == AuthMethod.phone ? "Send Verification Code →" : "Continue →",
                  onPressed: _selectedMethod == AuthMethod.phone ? _sendOtp : _handleSignUp,
                  width: double.infinity,
                ),
        ],
      ),
    );
  }

  Widget _buildVerificationStep() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Icon(Icons.mark_email_unread_outlined, size: 60, color: Color(0xFF1E1E2C)),
        const SizedBox(height: 24),
        Text(
          _selectedMethod == AuthMethod.phone ? "Verify your phone" : "Verify your email",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          _selectedMethod == AuthMethod.phone 
              ? "We sent a 6-digit code to +${_selectedCountry.phoneCode} ${_phoneController.text}" 
              : "We sent a verification link to ${_emailController.text}",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 32),
        if (_selectedMethod == AuthMethod.phone) ...[
          _buildOtpFields(),
          const SizedBox(height: 24),
          TextButton(
            onPressed: _sendOtp,
            child: const Text("Resend code", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
          ),
          const Spacer(),
          _isLoading
              ? const CircularProgressIndicator()
              : GlassButton(
                  label: "Verify & Finish",
                  onPressed: _verifyOtp,
                  width: double.infinity,
                ),
        ] else ...[
          const Spacer(),
          GlassButton(
            label: "Check Mailbox",
            onPressed: () {
              // Usually apps open email client or just go home
              context.go('/');
            },
            width: double.infinity,
          ),
        ],
      ],
    );
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return Container(
          width: 45,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: const TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: "",
            ),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      }),
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

  Future<void> _handleSignUp() async {
    if (_selectedMethod == AuthMethod.email && _passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_selectedMethod == AuthMethod.email) {
        await _authService.signUpEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        // Set display name
        await _authService.updateUserProfile(displayName: _nameController.text.trim());
        _nextStep(); // Go to verification
      } else {
        // For phone or google, logic is handled elsewhere or by _sendOtp
        _nextStep();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign up failed: ${e.toString()}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your phone number')));
      return;
    }

    final fullPhone = "+${_selectedCountry.phoneCode}$phone";
    if (kIsWeb && _verifier == null) {
      _verifier = RecaptchaVerifier(
        auth: FirebaseAuth.instance as dynamic,
        container: 'recaptcha-container',
        size: RecaptchaVerifierSize.normal,
        theme: RecaptchaVerifierTheme.light,
      );
    }

    setState(() => _isLoading = true);
    try {
      await _authService.verifyPhoneNumber(
        phoneNumber: fullPhone,
        applicationVerifier: kIsWeb ? _verifier : null,
        codeSent: (id, token) {
          setState(() {
            _verificationId = id;
            _isLoading = false;
          });
          _nextStep(); // Go to OTP step
        },
        verificationFailed: (e) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Verification failed')));
        },
        verificationCompleted: (creds) async {
          await FirebaseAuth.instance.signInWithCredential(creds);
          if (mounted) context.go('/');
        }
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _verifyOtp() async {
    // Collect OTP from fields (in a real app, use a controller or one field)
    // For now, simulating with a 6-digit string
    final code = "123456"; 
    
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

enum AuthMethod { email, phone }

