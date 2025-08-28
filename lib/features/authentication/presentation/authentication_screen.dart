import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knownbase/core/constants/k_fonts.dart';
import 'package:knownbase/core/theme/theme_provider.dart';
import '../../../core/constants/k_sizes.dart';
import '../application/authentication_cubit.dart';
import '../application/authentication_state.dart';
import 'widgets/authentication_form_widget.dart';
import 'widgets/social_login_button.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(KSize.md),
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

              return _buildAuthenticationForm(context, state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAuthenticatedView(BuildContext context, AuthenticationState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:  [
       const  Icon(
          Icons.check_circle,
          size: KSize.iconSizeXLarge,
          color: Colors.green,
        ),
        const SizedBox(height: KSize.md),
        const Text(
          'Welcome!',
          style: TextStyle(
            fontSize: KFonts.md,
            fontWeight: KFonts.medium,
          ),
        ),
        const SizedBox(height: KSize.sm),
        if (state.currentUser != null) ...[
          Text(
            'Signed in as: ${state.currentUser!['email'] ?? 'Unknown'}',
            style: TextStyle(
              fontSize: KSize.fontSizeM,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: KSize.md),
        ],
        SizedBox(
          width: double.infinity,
          height: KSize.buttonHeightDefault,
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

  Widget _buildAuthenticationForm(BuildContext context, AuthenticationState state) {
    return Container(
      padding: const EdgeInsets.all(KSize.md),
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        borderRadius: BorderRadius.circular(KSize.radiusDefault),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: KSize.iconSizeXLarge,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: KSize.md),
          Text(
            state.isSignInMode ? 'Sign In' : 'Sign Up',
            style: const TextStyle(
              fontSize: KFonts.md,
            fontWeight: KFonts.medium,
            ),
          ),
          const SizedBox(height: KSize.sm),
          Text(
            state.isSignInMode
                ? 'Welcome back! Please sign in to your account.'
                : 'Create a new account to get started.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: KSize.fontSizeM,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: KSize.lg),
          const AuthenticationFormWidget(),
          const SizedBox(height: KSize.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.isSignInMode
                    ? "Don't have an account? "
                    : 'Already have an account? ',
                style: TextStyle(
                  fontSize: KFonts.md,
                  color: Colors.grey[600],
                ),
              ),
              TextButton(
                onPressed: () => context.read<AuthenticationCubit>().toggleMode(),
                child: Text(
                  state.isSignInMode ? 'Sign Up' : 'Sign In',
                  style: const TextStyle(
fontSize: KFonts.md,
              fontWeight: KFonts.medium,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
