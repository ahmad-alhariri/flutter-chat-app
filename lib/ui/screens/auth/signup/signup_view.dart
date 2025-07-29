import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/paths.dart';
import 'package:flutter_chat_app/ui/screens/auth/auth_viewmodel.dart';
import 'package:flutter_chat_app/ui/widgets/beizer_container_widget.dart';
import 'package:flutter_chat_app/ui/widgets/custom_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignupView extends StatefulWidget {
  final VoidCallback onToggleView;
  const SignupView({super.key, required this.onToggleView});
  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final auth = context.read<AuthViewModel>();
      final success = await auth.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _usernameController.text.trim(),
      );
      if (success && mounted) {
        Navigator.of(context).pushReplacementNamed(home);
      } else if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(auth.errorMessage ?? 'An unknown error occurred.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final viewModel = context.watch<AuthViewModel>();
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SizedBox(
        height: height,
        child: Stack(
          children: <Widget>[
            const Positioned(top: 0, left: 0, right:0, child: BezierContainer()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    Image.asset(logo, height: 100.h,),
                    Text("Create Account", style: textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground,
                    )),
                    Text("Start your journey with us", style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.6)
                    )),
                    SizedBox(height: 30.h),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            labelText: "Username",
                            prefixIcon: Icons.person_outline,
                            controller: _usernameController,
                            validator: (v) => v!.isEmpty ? "Username is required" : null,
                          ),
                          SizedBox(height: 12.h),
                          CustomTextField(
                            labelText: "Email",
                            prefixIcon: Icons.email_outlined,
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email';
                              }
                              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                              if (!emailRegex.hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 12.h),
                          CustomTextField(
                            labelText: "Password",
                            prefixIcon: Icons.lock_outline,
                            controller: _passwordController,
                            obscureText: true,
                            validator: (v) => v!.length < 6 ? "Password must be at least 6 characters" : null,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: viewModel.isBusy ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        minimumSize: Size(double.infinity, 50.h),
                      ),
                      child: viewModel.isBusy
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text('Register', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: height * .055),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Already have an account ? ",
                        style: textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = widget.onToggleView,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}