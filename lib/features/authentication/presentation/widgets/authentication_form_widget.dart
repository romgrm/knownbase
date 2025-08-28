import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../application/authentication_cubit.dart';
import '../../application/authentication_state.dart';

/// Widget for the authentication form (email and password inputs)
class AuthenticationFormWidget extends StatefulWidget {
  const AuthenticationFormWidget({super.key});

  @override
  State<AuthenticationFormWidget> createState() => _AuthenticationFormWidgetState();
}

class _AuthenticationFormWidgetState extends State<AuthenticationFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    context.read<AuthenticationCubit>().updateEmail(_emailController.text);
  }

  void _onPasswordChanged() {
    context.read<AuthenticationCubit>().updatePassword(_passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              _buildEmailField(state),
              const SizedBox(height: 16),
              _buildPasswordField(state),
              const SizedBox(height: 24),
              _buildSubmitButton(state),
              const SizedBox(height: 16),
              _buildErrorMessages(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmailField(AuthenticationState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: context.textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Enter your email',
          ),
          enabled: !state.isSignInLoading && !state.isSignUpLoading,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!state.credentials.isEmailValid) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField(AuthenticationState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: context.textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          enabled: !state.isSignInLoading && !state.isSignUpLoading,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (!state.credentials.isPasswordValid) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton(AuthenticationState state) {
    final isLoading = state.isSignInLoading || state.isSignUpLoading;
    final buttonText = state.isSignInMode ? 'Sign In' : 'Sign Up';

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : _onSubmit,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                buttonText,
                style: context.textTheme.labelLarge,
              ),
      ),
    );
  }

  Widget _buildErrorMessages(AuthenticationState state) {
    final errors = <String>[];

    if (state.hasSignInError) {
      errors.add(state.signInState.errorMessage ?? 'Sign in failed');
    }

    if (state.hasSignUpError) {
      errors.add(state.signUpState.errorMessage ?? 'Sign up failed');
    }

    if (errors.isEmpty) return const SizedBox.shrink();

    return Column(
      children: errors.map((error) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: context.colorScheme.error,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.colorScheme.error),
          ),
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: context.colorScheme.onError,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  error,
                  style: TextStyle(
                    color: context.colorScheme.onError,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final cubit = context.read<AuthenticationCubit>();
      if (context.read<AuthenticationCubit>().state.isSignInMode) {
        cubit.signIn();
      } else {
        cubit.signUp();
      }
    }
  }
}
