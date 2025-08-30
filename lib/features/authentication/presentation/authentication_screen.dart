import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knownbase/core/constants/k_fonts.dart';
import '../../../core/constants/k_sizes.dart';
import '../../../shared/buttons/social_sign_in_button.dart';
import '../application/authentication_cubit.dart';
import '../application/authentication_state.dart';
import 'widgets/authentication_form_widget.dart';

/// Main authentication screen that handles both sign in and sign up
class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationCubit()..initialize(),
      child: const AuthenticationView(),
    );
  }
}

class AuthenticationView extends StatelessWidget {
  const AuthenticationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, state) {
            if (state.isCheckingAuthentication) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.isAuthenticated) {
              return _buildAuthenticatedView(context, state);
            }

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
    );
  }

  Widget _buildAuthenticatedView(BuildContext context, AuthenticationState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.check_circle,
          size: KSize.iconSizeXLarge,
          color: Colors.green,
        ),
        const SizedBox(height: KSize.md),
        Text(
          'Welcome!',
          style: KFonts.headlineMedium.copyWith(color: Colors.black),
        ),
        const SizedBox(height: KSize.sm),
        if (state.currentUser != null) ...[
          Text(
            'Signed in as: ${state.currentUser!['email'] ?? 'Unknown'}',
            style: KFonts.bodyMedium.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: KSize.md),
        ],
        Container(
          width: double.infinity,
          height: KSize.buttonHeightDefault,
          margin: const EdgeInsets.symmetric(horizontal: KSize.xl),
          child: ElevatedButton(
            onPressed: () => context.read<AuthenticationCubit>().signOut(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthenticationModal(BuildContext context, AuthenticationState state) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFA199FA),
        borderRadius: BorderRadius.circular(21),
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
                        // TODO: Implement forgot password
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
}
