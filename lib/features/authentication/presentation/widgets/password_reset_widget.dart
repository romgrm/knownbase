import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/k_sizes.dart';
import '../../../../core/constants/k_fonts.dart';
import '../../../authentication/application/authentication_cubit.dart';
import '../../../authentication/application/authentication_state.dart';

class PasswordResetWidget extends StatefulWidget {
  const PasswordResetWidget({super.key});

  @override
  State<PasswordResetWidget> createState() => _PasswordResetWidgetState();
}

class _PasswordResetWidgetState extends State<PasswordResetWidget> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Reset Password',
                style: KFonts.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: KSize.lg),
              Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                style: KFonts.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: KSize.xl),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !state.isPasswordResetLoading,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email address',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              if (state.hasPasswordResetError) ...[
                const SizedBox(height: KSize.sm),
                Container(
                  padding: const EdgeInsets.all(KSize.sm),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(KSize.radiusDefault),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const SizedBox(width: KSize.xs),
                      Expanded(
                        child: Text(
                          'Password reset failed. Please try again.',
                          style: KFonts.bodySmall.copyWith(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (state.isPasswordResetSuccess) ...[
                const SizedBox(height: KSize.sm),
                Container(
                  padding: const EdgeInsets.all(KSize.sm),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(KSize.radiusDefault),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                      const SizedBox(width: KSize.xs),
                      Expanded(
                        child: Text(
                          'Password reset email sent! Check your inbox.',
                          style: KFonts.bodySmall.copyWith(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: KSize.xl),
              ElevatedButton(
                onPressed: state.isPasswordResetLoading
                    ? null
                    : () {
                        if (_formKey.currentState?.validate() == true) {
                          context
                              .read<AuthenticationCubit>()
                              .resetPassword(_emailController.text.trim());
                        }
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, KSize.buttonHeightDefault),
                ),
                child: state.isPasswordResetLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('Send Reset Email', style: KFonts.buttonLarge),
              ),
              const SizedBox(height: KSize.lg),
              TextButton(
                onPressed: () {
                  context.read<AuthenticationCubit>().clearPasswordResetState();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Back to Sign In',
                  style: KFonts.bodyMedium,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}