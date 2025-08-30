import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knownbase/shared/input_fields/input_field.dart';
import '../../../../core/constants/k_sizes.dart';
import '../../../../core/constants/k_fonts.dart';
import '../../../../core/router/app_router.dart';
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
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        // Navigate to dashboard when sign-in or sign-up is successful
        if (state.isSignInSuccess || state.isSignUpSuccess) {
          AppRouter.navigateToDashboard(context);
        }
      },
      child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildEmailField(state),
                const SizedBox(height: KSize.md),
                _buildPasswordField(state),
                const SizedBox(height: KSize.lg),
                _buildSubmitButton(state),
                if (state.hasSignInError || state.hasSignUpError) ...[
                  const SizedBox(height: KSize.md),
                  _buildErrorMessages(state),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmailField(AuthenticationState state) {
    return InputField(
      controller: _emailController,
      label: 'Email',
      keyboardType: TextInputType.emailAddress,
      hintText: 'Enter your email',
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
    );
  }

  Widget _buildPasswordField(AuthenticationState state) {
    return InputField(
      controller: _passwordController,
      label: 'Password',
      obscureText: _obscurePassword,
      hintText: 'Enter your password',
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: Colors.white.withOpacity(0.7),
          size: KSize.iconSizeDefault,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
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
    );
  }

  Widget _buildSubmitButton(AuthenticationState state) {
    final isLoading = state.isSignInLoading || state.isSignUpLoading;
    final buttonText = state.isSignInMode ? 'Sign In' : 'Sign Up';

    return Container(
      height: KSize.buttonHeightDefault,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(KSize.radiusDefault),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : _onSubmit,
          borderRadius: BorderRadius.circular(KSize.radiusDefault),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: KSize.md,
                    width: KSize.md,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA199FA)),
                    ),
                  )
                : Text(
                    buttonText,
                    style: KFonts.labelMedium.copyWith(
                      color: const Color(0xFFA199FA),
                      fontWeight: KFonts.semiBold,
                    ),
                  ),
          ),
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
          padding: const EdgeInsets.all(KSize.xs),
          margin: const EdgeInsets.only(bottom: KSize.xxs),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(KSize.radiusDefault),
            border: Border.all(
              color: Colors.red.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: KSize.md,
              ),
              const SizedBox(width: KSize.xxs),
              Expanded(
                child: Text(
                  error,
                  style: KFonts.bodySmall.copyWith(
                    color: Colors.white,
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
