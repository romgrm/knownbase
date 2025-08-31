import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knownbase/core/constants/k_fonts.dart';
import '../../../core/constants/k_sizes.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/app_logger.dart';
import '../../../shared/buttons/social_sign_in_button.dart';
import '../application/authentication_cubit.dart';
import '../application/authentication_state.dart';
import 'widgets/authentication_form_widget.dart';
import 'widgets/password_reset_widget.dart';

/// Main authentication screen that handles both sign in and sign up
class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthenticationView();
  }
}

class AuthenticationView extends StatelessWidget {
  const AuthenticationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'KnownBase',
          style: KFonts.titleLarge.copyWith(
            color: Colors.black,
            fontWeight: KFonts.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[50]!,
              Colors.grey[100]!,
              Colors.grey[200]!,
            ],
          ),
        ),
        child: SafeArea(
          child: BlocListener<AuthenticationCubit, AuthenticationState>(
            listener: (context, state) {
              // Navigate to dashboard when authentication is successful
              if (state.isAuthenticated && !state.isCheckingAuthentication) {
                AppLogger.navigationTo('Dashboard');
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  AppRouter.navigateToDashboard(context);
                });
              }
            },
            child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, state) {
                if (state.isCheckingAuthentication) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Show authentication form when not authenticated
                return Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    margin: const EdgeInsets.all(KSize.lg),
                    child: _buildAuthenticationModal(context, state),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildAuthenticationModal(BuildContext context, AuthenticationState state) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFA199FA),
        borderRadius: BorderRadius.circular(KSize.radiusXLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 25,
            offset: const Offset(0, 12),
            spreadRadius: -12,
          ),
        ],
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(KSize.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Add close functionality if needed
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: KSize.iconSizeDefault,
                      ),
                    ),
                  ],
                ),
                
                // Title
                Text(
                  state.isSignInMode ? 'Welcome back' : 'Create account',
                  textAlign: TextAlign.center,
                  style: KFonts.headlineMedium.copyWith(
                    color: Colors.white,
                    fontSize: 26.3,
                  ),
                ),
                const SizedBox(height: KSize.sm),
                
                // Subtitle
                Text(
                  state.isSignInMode ? 'Sign in to your account' : 'Create a new account to get started',
                  textAlign: TextAlign.center,
                  style: KFonts.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 15.8,
                  ),
                ),
                const SizedBox(height: KSize.lg),
                
                // Social sign-in buttons
                SocialSignInButton(
                  label: 'Continue with Google',
                  icon: const Icon(
                    Icons.g_mobiledata,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // TODO: Implement Google sign-in
                  },
                ),
                const SizedBox(height: KSize.sm),
                
                SocialSignInButton(
                  label: 'Continue with GitHub',
                  icon: const Icon(
                    Icons.hub,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // TODO: Implement GitHub sign-in
                  },
                ),
                const SizedBox(height: KSize.md),
                
                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: KSize.sm),
                      child: Text(
                        'or continue with email',
                        style: KFonts.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: KSize.md),
                
                // Email and Password form
                const AuthenticationFormWidget(),
                
                // Forgot password (only for sign in)
                if (state.isSignInMode) ...[
                  const SizedBox(height: KSize.sm),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        _showPasswordResetDialog(context);
                      },
                      child: Text(
                        'Forgot password?',
                        style: KFonts.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                ],
                
                const SizedBox(height: KSize.md),
                
                // Toggle between sign in and sign up
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      state.isSignInMode
                          ? "Don't have an account? "
                          : 'Already have an account? ',
                      style: KFonts.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.read<AuthenticationCubit>().toggleMode(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        state.isSignInMode ? 'Create account' : 'Sign in',
                        style: KFonts.labelMedium.copyWith(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: KSize.md),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPasswordResetDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            margin: const EdgeInsets.all(KSize.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(KSize.radiusMedium),
            ),
            child: const Padding(
              padding: EdgeInsets.all(KSize.lg),
              child: PasswordResetWidget(),
            ),
          ),
        );
      },
    );
  }
}
