import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:group_trip/features/auth/presentation/widgets/input_widget.dart';
import 'package:group_trip/features/auth/providers/user_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  // Regex patterns for password rules
  final RegExp _upperCaseReg = RegExp(r'[A-Z]');
  final RegExp _digitReg = RegExp(r'\d');
  final RegExp _specialCharReg = RegExp(r'[^A-Za-z0-9]');

  // Return a single error string for a form field validator (or null if valid)
  String? _validatePassword(String? value) {
    final v = value ?? '';
    if (v.length < 6) {
      return 'Passwords must be at least 6 characters.';
    }
    if (!_specialCharReg.hasMatch(v)) {
      return 'Passwords must have at least one non alphanumeric character.';
    }
    if (!_digitReg.hasMatch(v)) {
      return 'Passwords must have at least one digit (\'0\'-\'9\').';
    }
    if (!_upperCaseReg.hasMatch(v)) {
      return 'Passwords must have at least one uppercase (\'A\'-\'Z\').';
    }
    return null;
  }

  // Return a list of all unmet rules (useful for showing multiple messages)
  List<String> _passwordValidationErrors(String pwd) {
    final errors = <String>[];
    if (pwd.length < 6) {
      errors.add('Passwords must be at least 6 characters.');
    }
    if (!_specialCharReg.hasMatch(pwd)) {
      errors.add(
        'Passwords must have at least one non alphanumeric character.',
      );
    }
    if (!_digitReg.hasMatch(pwd)) {
      errors.add('Passwords must have at least one digit (\'0\'-\'9\').');
    }
    if (!_upperCaseReg.hasMatch(pwd)) {
      errors.add('Passwords must have at least one uppercase (\'A\'-\'Z\').');
    }
    return errors;
  }

  // Convenience boolean
  bool _isPasswordValid(String pwd) => _passwordValidationErrors(pwd).isEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    

    if (_formKey.currentState!.validate()) {
      final pwd = _passwordController.text;

      // Double-check passwords match
    
      // Validate password rules
      final pwdErrors = _passwordValidationErrors(pwd);
      if (pwdErrors.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(pwdErrors.join('\n'))));
        return;
      }
      print('✅ ref is ${ref.hashCode}');
      print('✅ notifier is ${ref.read(authNotifierProvider.notifier)}');
      final notifier = ref.read(authNotifierProvider.notifier);
      await notifier.login(_nameController.text, _passwordController.text);
     
      if (!mounted) return;

      // TODO: Gọi API register ở đây (ví dụ dùng Dio)
      final state = ref.read(authNotifierProvider);
      state.when(
        data: (user) {
          if (user != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Register successful!")),
            );
            context.push('/signin');
          }
        },
        error: (e, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        },
        loading: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AsyncLoading;

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Logo
                Center(
                  child: Image.asset('assets/images/logo.png', height: 90),
                ),
                const SizedBox(height: 30),

                // Title
                Text(
                  "Let’s Get Started",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Create your new account and find more\nbeautiful destinations",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),

                // Name
                AppTextField(
                  controller: _nameController,
                  label: "Name",
                  hint: "Enter your full name",
                  validator:
                      (value) =>
                          value!.isEmpty ? "Please enter your name" : null,
                ),
                const SizedBox(height: 16),

                // Email
               

                // Password
                AppTextField(
                  controller: _passwordController,
                  label: "Password",
                  hint: "Enter your password",
                  isPassword: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    final v = value ?? '';
                    final errs = _passwordValidationErrors(v);
                    return errs.isEmpty ? null : errs.join('\n');
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password
              

                // Accept Terms
                
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Google Sign-In pressed (implement here)',
                          ),
                        ),
                      );
                      // TODO: replace with real Google sign-in logic (google_sign_in / firebase_auth)
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png', // thay bằng url của bạn
                          height: 20,
                          width: 20,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const SizedBox(
                              height: 20,
                              width: 20,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                          errorBuilder:
                              (_, __, ___) =>
                                  const Icon(Icons.g_mobiledata, size: 20),
                        ),
                      ),
                    ),
                    label: const Text(
                      'Continue with Google',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),

                const SizedBox(height: 24),

                // Sign In link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        context.push('/');
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
