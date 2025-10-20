import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // initState mein hum AuthProvider ko sunne ke liye ek listener add karenge
    // taake UI build hone ke baad state changes ko handle kiya ja sake.
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.addListener(_onAuthChange);
  }

  @override
  void dispose() {
    // Screen khatam hone par listener ko remove karna zaroori hai
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.removeListener(_onAuthChange);
    _phoneController.dispose();
    super.dispose();
  }

  /// Yeh function AuthProvider mein hone wali har change par call hoga
  void _onAuthChange() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Agar koi error hai, to SnackBar dikhayein
    if (mounted && authProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.error!)),
      );
      // Yahan public function 'clearError' call ho raha hai
      authProvider.clearError(); // Error dikhane ke foran baad clear karein
    }

    // Agar verificationId aa gaya hai, to agli screen par navigate karein
    if (mounted && authProvider.verificationId != null) {
      Navigator.pushNamed(context, '/verify');
      authProvider.clearVerificationId(); // Navigate karne ke baad clear karein
    }
  }

  /// OTP bhejne ke liye function
  void _sendOTP() {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final phoneNumber = "+92${_phoneController.text.trim()}";
      authProvider.sendOTP(phoneNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Consumer sirf un widgets ko rebuild karega jinhein state ki zaroorat hai (jaise button)
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Spacer(flex: 1),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 350,
                    height: 350,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  "Welcome to ChatUp",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Please enter your phone number to continue",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 1),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Enter Phone Number",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          prefixText: '+92 ',
                          border: OutlineInputBorder(),
                          hintText: '3001234567',
                          labelText: 'Phone Number',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          if (value.length < 10) {
                            return 'Please enter a valid 10-digit number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        // Yahan Consumer ka istemal sirf button ki state update karne ke liye hai
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: authProvider.isLoading ? null : _sendOTP,
                              child: authProvider.isLoading
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                                  : const Text(
                                'Send OTP',
                                style: TextStyle(color: Colors.white, fontSize: 16),
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

