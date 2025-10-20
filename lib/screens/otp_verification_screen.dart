import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // AuthProvider mein hone wali changes ko sunne ke liye listener add karein
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.addListener(_onAuthChange);
  }

  @override
  void dispose() {
    // Screen khatam hone par listener ko remove karein
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.removeListener(_onAuthChange);
    _otpController.dispose();
    super.dispose();
  }

  /// Yeh function AuthProvider ki state changes par call hoga
  void _onAuthChange() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Agar koi error hai, to usay SnackBar mein dikhayein
    if (mounted && authProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.error!)),
      );
      authProvider.clearError(); // Error dikhane ke baad usay clear karein
    }

    // NOTE: Successful login par navigation 'AuthGate' khud handle kar lega.
    // Jab user verify ho jayega, authStateChanges stream event bhejega
    // aur AuthGate user ko home screen par bhej dega.
  }

  /// OTP verify karne ke liye function
  void _verifyOTP() {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final otpCode = _otpController.text.trim();
      authProvider.verifyOTP(otpCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Spacer(flex: 1),
                Image.asset(
                  'assets/images/logo.png',
                  height: 350,
                  width: 350,
                ),
                const SizedBox(height: 14),
                const Text(
                  'OTP Verification',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter the 6-digit code sent to your phone',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54, // Color behtar readability ke liye
                    fontSize: 16,
                  ),
                ),
                const Spacer(flex: 1),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Enter OTP',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        textAlign: TextAlign.center, // OTP center mein behtar lagta hai
                        style: const TextStyle(fontSize: 20, letterSpacing: 8), // Spacing for OTP
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '123456',
                          counterText: '',
                          labelText: 'OTP Code',
                        ),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Please enter a valid 6-digit OTP';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        // Consumer ka istemal sirf button ki state update karne ke liye
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: authProvider.isLoading ? null : _verifyOTP,
                              child: authProvider.isLoading
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                                  : const Text(
                                'Verify & Continue',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
