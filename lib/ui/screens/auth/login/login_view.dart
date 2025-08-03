import 'package:flutter/gestures.dart';
import 'package:flutter_chat_app/core/constants/paths.dart';
import 'package:flutter_chat_app/core/enums/enums.dart';
import 'package:flutter_chat_app/core/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ui/widgets/auth_scaffold.dart';
import 'package:flutter_chat_app/ui/widgets/beizer_container_widget.dart';
import 'package:flutter_chat_app/ui/widgets/custom_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../widgets/auth_logo_widget.dart';

// ==================================================
// PURPOSE: The UI for the login screen. It is a "dumb" widget that gets its
// state and logic from the AuthViewModel.
// ==================================================
class LoginView extends StatefulWidget {
  final VoidCallback onToggleView;
  const LoginView({super.key, required this.onToggleView});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AuthViewModel _authViewModel; // Store a reference to the ViewModel

  @override
  void initState() {
    super.initState();
    // Get the ViewModel instance once and add the listener.
    _authViewModel = context.read<AuthViewModel>();
    _authViewModel.addListener(_onViewModelUpdate);
  }

  @override
  void dispose() {
    // Use the stored reference to remove the listener, avoiding context usage.
    _authViewModel.removeListener(_onViewModelUpdate);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onViewModelUpdate() {
    if (_authViewModel.state == ViewState.Error &&
        _authViewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authViewModel.errorMessage!),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final auth = context.read<AuthViewModel>();
      final success = await auth.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // Use context.watch to rebuild the widget when the ViewModel's state changes.
    final viewModel = context.watch<AuthViewModel>();
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: height * .2),
          AuthLogoWidget(
            textTheme: textTheme,
            colorScheme: colorScheme,
            text: "Welcome Back",
            subText: "Login to continue",
          ),
          SizedBox(height: 20.h),
          Form(
            key: _formKey,
            child: Column(
              children: [
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
                SizedBox(height: 13.h),
                CustomTextField(
                  labelText: "Password",
                  prefixIcon: Icons.lock_outline,
                  controller: _passwordController,
                  obscureText: true,
                  validator: (v) => v!.isEmpty ? "Password is required" : null,
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: viewModel.isBusy ? null : _submit,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              minimumSize: Size(double.infinity, 50.h),
            ),
            child: viewModel.isBusy
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          SizedBox(height: height * .1),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Don't have an account ? ",
              style: textTheme.titleMedium,
              children: [
                TextSpan(
                  text: 'Register',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = widget.onToggleView,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
