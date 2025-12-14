import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:group_trip/features/auth/data/user_model.dart';
import 'package:group_trip/features/auth/presentation/widgets/input_widget.dart';
import 'package:group_trip/features/auth/presentation/widgets/term_of_service_bottom_sheet.dart';
import 'package:group_trip/features/auth/providers/user_provider.dart';
import 'package:dio/dio.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
      return 'Mật khẩu phải có ít nhất 6 ký tự.';
    }
    if (!_specialCharReg.hasMatch(v)) {
      return 'Mật khẩu phải có ít nhất một ký tự đặc biệt.';
    }
    if (!_digitReg.hasMatch(v)) {
      return 'Mật khẩu phải có ít nhất một số (0-9).';
    }
    if (!_upperCaseReg.hasMatch(v)) {
      return 'Mật khẩu phải có ít nhất một chữ hoa (A-Z).';
    }
    return null;
  }

  // Return a list of all unmet rules (useful for showing multiple messages)
  List<String> _passwordValidationErrors(String pwd) {
    final errors = <String>[];
    if (pwd.length < 6) {
      errors.add('Mật khẩu phải có ít nhất 6 ký tự.');
    }
    if (!_specialCharReg.hasMatch(pwd)) {
      errors.add(
        'Mật khẩu phải có ít nhất một ký tự đặc biệt.',
      );
    }
    if (!_digitReg.hasMatch(pwd)) {
      errors.add('Mật khẩu phải có ít nhất một số (0-9).');
    }
    if (!_upperCaseReg.hasMatch(pwd)) {
      errors.add('Mật khẩu phải có ít nhất một chữ hoa (A-Z).');
    }
    return errors;
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      print('🟢 Google Sign-In started');

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId:
            '153605106227-lejscv0ptvd84avur70kqi0b85hdhnla.apps.googleusercontent.com',
        scopes: ['email', 'profile'],
      );

      // ✅ Buộc đăng xuất để refresh lại token
      await googleSignIn.signOut();

      // ✅ Đăng nhập lại
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign-in cancelled')),
        );
        return;
      }

      // ✅ Lấy token mới sau khi đăng nhập
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print('✅ Google Sign-In success');
      print('🆕 ID Token (new): ${googleAuth.idToken}');
      print('🔑 Access Token: ${googleAuth.accessToken}');

      // 👉 Tại đây bạn có thể gửi googleAuth.idToken lên backend để verify
      // await yourAuthRepository.verifyGoogleToken(googleAuth.idToken);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chào mừng, ${googleUser.displayName ?? 'Người dùng'}')),
      );
    } catch (e, st) {
      print('❌ Google sign-in error: $e');
      print('🔍 StackTrace: $st');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã hủy đăng nhập Google')));
    }
  }

  // Convenience boolean
  bool _isPasswordValid(String pwd) => _passwordValidationErrors(pwd).isEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chấp nhận điều khoản dịch vụ")),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final pwd = _passwordController.text;
      final confirm = _confirmPasswordController.text;

      // Double-check passwords match
      if (pwd != confirm) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Mật khẩu không khớp')));
        return;
      }

      // Validate password rules
      final pwdErrors = _passwordValidationErrors(pwd);
      if (pwdErrors.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(pwdErrors.join('\n'))));
        return;
      }
      print('✅ ref is ${ref.hashCode}');
      print('✅ notifier is ${ref.read(registerNotifierProvider.notifier)}');
      final notifier = ref.read(registerNotifierProvider.notifier);
      await notifier.register(
        UserModel(
          username: _emailController.text,
          fullName: _nameController.text,
          password: pwd,
          confirmPassword: confirm,
          email: _emailController.text,
          bankAccount: '',
          bankName: '',
          role: 'Traveller',
        ),
      );
      if (!mounted) return;

      // TODO: Gọi API register ở đây (ví dụ dùng Dio)
      final state = ref.read(registerNotifierProvider);
      state.when(
        data: (success) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
          content: Text('Đăng ký thành công!'),
              ),
            );

            // '/' is the login route now
            context.push('/');
          }
        },
        error: (e, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
        },
        loading: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerNotifierProvider);
    final isLoading = registerState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

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
                  "Bắt đầu ngay",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Tạo tài khoản mới của bạn và khám phá\nthêm nhiều điểm đến tuyệt đẹp",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),

                // Name
                AppTextField(
                  controller: _nameController,
                  label: "Tên",
                  hint: "Nhập tên đầy đủ của bạn",
                  validator:
                      (value) =>
                          value!.isEmpty ? "Vui lòng nhập tên của bạn" : null,
                ),
                const SizedBox(height: 16),

                // Email
                AppTextField(
                  controller: _emailController,
                  label: "Email",
                  hint: "Nhập email của bạn",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập email";
                    } else if (!value.contains('@')) {
                      return "Nhập email hợp lệ";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                AppTextField(
                  controller: _passwordController,
                  label: "Mật khẩu",
                  hint: "Nhập mật khẩu của bạn",
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
                AppTextField(
                  controller: _confirmPasswordController,
                  label: "Nhập lại mật khẩu",
                  hint: "Nhập lại mật khẩu của bạn",
                  isPassword: true,
                  validator:
                      (value) =>
                          value != _passwordController.text
                              ? "Mật khẩu không khớp"
                              : null,
                ),
                const SizedBox(height: 12),

                // Accept Terms
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged:
                          (val) => setState(() => _acceptTerms = val ?? false),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: "Tôi chấp nhận ",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "điều khoản dịch vụ",
                              style: const TextStyle(color: Colors.red),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      // 👉 Xử lý khi người dùng nhấn vào đây
                                      showTravellerTermsSheet(context);
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: _handleGoogleSignIn,
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
                      'Tiếp tục với Google',
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
                              "Đăng ký",
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
                    const Text("Đã có tài khoản? "),
                    GestureDetector(
                      onTap: () {
                        context.push('/');
                      },
                      child: const Text(
                        "Đăng nhập",
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
