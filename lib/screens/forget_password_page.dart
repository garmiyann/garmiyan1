import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final contactController = TextEditingController();
  String selectedLanguage = 'English';
  String? contactError;

  void _resetPassword() async {
    setState(() {
      contactError = null;
    });

    final input = contactController.text.trim();

    if (input.isEmpty) {
      setState(() {
        contactError = 'Please enter your email or phone number.';
      });
      return;
    }

    if (input.contains('@')) {
      // Email Reset Logic
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: input);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Reset Link Sent"),
            content: const Text("Check your email for a password reset link."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } on FirebaseAuthException catch (e) {
        String message = 'An error occurred.';
        if (e.code == 'user-not-found') {
          message = 'No account found with that email.';
        } else {
          message = e.message ?? message;
        }
        setState(() {
          contactError = message;
        });
      }
    } else {
      // Phone Reset Logic - Firebase doesn't support it directly
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Reset via Phone"),
          content: const Text(
              "Password reset by phone is not supported directly.\n\nTo reset using phone, please contact support or use the login with phone feature."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Choose Language"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text("🇰🇷", style: TextStyle(fontSize: 20)),
              title: const Text("Kurdish"),
              onTap: () {
                setState(() => selectedLanguage = 'Kurdish');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text("🇸🇦", style: TextStyle(fontSize: 20)),
              title: const Text("Arabic"),
              onTap: () {
                setState(() => selectedLanguage = 'Arabic');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text("🇺🇸", style: TextStyle(fontSize: 20)),
              title: const Text("English"),
              onTap: () {
                setState(() => selectedLanguage = 'English');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCGCInfo() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("About CGC",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          "CGC (Creative Global Company) is an innovative tech company providing modern e-commerce, shipping, and AI solutions to users across the globe.",
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text("Close", style: TextStyle(color: Color(0xFF740097))),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Forget Password",
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: _showLanguageDialog,
            icon: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Text("🌐", style: TextStyle(fontSize: 24)),
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7D00B8), Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/onboarding/get_started.png', height: 160),
                const SizedBox(height: 30),
                Text(
                  "Reset Password",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Enter your email or phone to receive a reset link.",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contactController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Email or Phone Number",
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon:
                        const Icon(Icons.person_outline, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    errorText: contactError,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF740097),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Send Reset Link",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.only(top: 8.0, right: 5.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontStyle: FontStyle.normal,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: GestureDetector(
                    onTap: _showCGCInfo,
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Powered by ',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          TextSpan(
                            text: 'CGC',
                            style: TextStyle(
                              color: Color(0xFF00BFFF),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
