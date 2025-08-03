// at top
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';
import '../main_home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();

  // Error map and error widget
  Map<String, String> errors = {};

  Widget _buildError(String? message) {
    return message != null
        ? Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Text(
              message,
              style: const TextStyle(color: Colors.red, fontSize: 12),
              textAlign: TextAlign.start,
            ),
          )
        : const SizedBox.shrink();
  }

  final phoneController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  String selectedDialCode = '+964'; // Default Iraq
  final List<String> dialCodes = ['+964', '+90', '+1', '+44', '+971', '+966'];
  final nameController = TextEditingController();
  final emailOrPhoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;
  String selectedLanguage = 'English';
  String selectedCountry = '🇮🇶 Iraq';

  final List<String> countries = [
    '🇮🇶 Iraq',
    '🇹🇷 Turkey',
    '🇺🇸 USA',
    '🇬🇧 UK',
    '🇦🇪 UAE',
    '🇸🇦 Saudi Arabia',
  ];

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                const Text("Close", style: TextStyle(color: Color(0xFFB700FF))),
          )
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14), // ✅ Rounded corners
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white70, width: 1),
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
        actions: [
          IconButton(
            onPressed: _showLanguageDialog,
            icon: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Text(
                "🌐",
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7D00B8), Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Image.asset('assets/onboarding/get_started.png', height: 160),
                const SizedBox(height: 20),
                Text(
                  "Create Account",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Sign up to get started",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 32),

                // First Name + Last Name
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: firstNameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                                "First Name", Icons.person_outline),
                          ),
                          _buildError(errors['firstName']),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: lastNameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                                "Last Name", Icons.person_outline),
                          ),
                          _buildError(errors['lastName']),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Username Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: usernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration("Username", Icons.person),
                    ),
                    _buildError(errors['username']),
                  ],
                ),
                const SizedBox(height: 16),
                // Email Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration:
                          _inputDecoration("Email", Icons.email_outlined),
                    ),
                    _buildError(errors['email']),
                  ],
                ),
                const SizedBox(height: 16),

                // Phone Number: Dial Code + Number Field
                Row(
                  children: [
                    // Dial Code Dropdown
                    Container(
                      width: 90,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedDialCode,
                          dropdownColor: Colors.deepPurple.shade800,
                          style: const TextStyle(color: Colors.white),
                          items: dialCodes.map((code) {
                            return DropdownMenuItem(
                              value: code,
                              child: Text(code),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => selectedDialCode = value!);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Phone Number TextField
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                                "Phone Number", Icons.phone_android),
                          ),
                          _buildError(errors['phone']),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCountry,
                  dropdownColor: Colors.deepPurple.shade800,
                  style: const TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.white,
                  decoration:
                      _inputDecoration("Select Country", Icons.flag_outlined),
                  items: countries.map((country) {
                    return DropdownMenuItem(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedCountry = value!);
                  },
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: passwordController,
                      obscureText: !showPassword,
                      style: const TextStyle(color: Colors.white),
                      decoration:
                          _inputDecoration("Password", Icons.lock_outline)
                              .copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () =>
                              setState(() => showPassword = !showPassword),
                        ),
                      ),
                    ),
                    _buildError(errors['password']),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: !showConfirmPassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(
                              "Confirm Password", Icons.lock_outline)
                          .copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            showConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () => setState(
                              () => showConfirmPassword = !showConfirmPassword),
                        ),
                      ),
                    ),
                    _buildError(errors['confirm']),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final firstName = firstNameController.text.trim();
                      final lastName = lastNameController.text.trim();
                      final username = usernameController.text.trim();
                      final email = emailController.text.trim();
                      final phone =
                          '$selectedDialCode${phoneController.text.trim()}';
                      final password = passwordController.text.trim();
                      final confirm = confirmPasswordController.text.trim();

                      errors.clear();

                      if (firstName.isEmpty)
                        errors['firstName'] = 'First name is required';
                      if (lastName.isEmpty)
                        errors['lastName'] = 'Last name is required';
                      if (username.isEmpty)
                        errors['username'] = 'Username is required';
                      if (email.isEmpty) errors['email'] = 'Email is required';
                      if (phone.isEmpty)
                        errors['phone'] = 'Phone number is required';
                      if (password.isEmpty)
                        errors['password'] = 'Password is required';
                      if (confirm.isEmpty)
                        errors['confirm'] = 'Confirm your password';
                      if (password != confirm)
                        errors['confirm'] = 'Passwords do not match';

                      if (errors.isNotEmpty) {
                        setState(() {});
                        return;
                      }

                      try {
                        // 🔍 Check if username exists
                        final query = await FirebaseFirestore.instance
                            .collection('users')
                            .where('username', isEqualTo: username)
                            .limit(1)
                            .get();
                        if (query.docs.isNotEmpty) {
                          errors['username'] = 'Username already exists';
                          setState(() {});
                          return;
                        }

                        // 👤 Create Firebase user
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        // 🔥 Add Firestore profile after registration
                        final user = FirebaseAuth.instance.currentUser;
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .set({
                          'fullName':
                              '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
                          'firstName': firstNameController.text.trim(),
                          'lastName': lastNameController.text.trim(),
                          'username': usernameController.text.trim(),
                          'email': user.email,
                          'phone': phone,
                          'country': selectedCountry,
                          'bio': '',
                          'profileImage': '',
                          'createdAt': FieldValue.serverTimestamp(),
                        });

                        if (mounted) {
                          Navigator.of(context, rootNavigator: true)
                              .pushReplacement(
                            MaterialPageRoute(
                                builder: (_) => const MainHomePage()),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          errors['email'] = e.message ?? 'Registration failed';
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB700FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Register",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_ios,
                            size: 18, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ",
                        style: TextStyle(color: Colors.white)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Color(0xFFFF8C00)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // 🟦 Powered by CGC with colored split text
                GestureDetector(
                  onTap: _showCGCInfo,
                  child: RichText(
                    text: const TextSpan(
                      text: 'Powered by ',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      children: [
                        TextSpan(
                          text: 'CGC',
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
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
