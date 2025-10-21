import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String? _verificationId;
  int? _resendToken; // <-- 1. ADD STATE VARIABLE FOR THE TOKEN
  bool _isOtpSent = false;
  bool _isLoading = false;

  void _onSendOtp() async {
    _otpController.clear();
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a phone number")),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });

    // NEW LOGIC: Wrap the service call in a try-catch block
    try {
      String phoneNumber = "+91${_phoneController.text.trim()}";
      await _authService.sendOtp(
        phoneNumber: phoneNumber,
        forceResendingToken:
            _resendToken, // <-- 2. PASS THE TOKEN (will be null the first time)
        onCodeSent: (verificationId, resendToken) {
          // 3. STORE BOTH THE VERIFICATION ID AND THE NEW RESEND TOKEN
          setState(() {
            _verificationId = verificationId;
            _resendToken = resendToken;
            _isOtpSent = true;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("OTP has been sent!")));
        },
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Failed to send OTP")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onVerifyOtp() async {
    if (_verificationId == null || _otpController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter the OTP")));
      return;
    }
    setState(() {
      _isLoading = true;
    });

    // NEW LOGIC: Wrap the service call in a try-catch block
    try {
      await _authService.verifyOtp(
        verificationId: _verificationId!,
        smsCode: _otpController.text.trim(),
      );

      // NEW LOGIC: If the await completes without an error, it was a success.
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login Successful!")));
      // You can now navigate to the next screen here
    } on FirebaseAuthException catch (e) {
      // NEW LOGIC: The UI is now responsible for showing the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Failed to verify OTP")),
      );
    } finally {
      // This ensures the loading spinner always hides, even on error
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This entire build method does not need to change at all.
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                prefixText: "+91 ",
                border: OutlineInputBorder(),
              ),
              enabled: !_isOtpSent,
            ),
            const SizedBox(height: 20),
            if (_isOtpSent)
              Column(
                children: [
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "OTP",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : _onSendOtp, // The same function handles both send and resend
                  child: const Text("Resend OTP"),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : (_isOtpSent ? _onVerifyOtp : _onSendOtp),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(_isOtpSent ? "Verify OTP" : "Send OTP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
